# Global concern for controllers in the Explore namespace. Defines which methods are executed on each request.
module WhitelabExplore
  extend ActiveSupport::Concern

  included do
    before_filter :set_query
    before_filter :set_document
    before_filter :set_grouping
    before_filter :set_filter
    before_filter :set_filtered_amount
  end
  
  protected
  
  # Set current document
  def set_document
    @document = Document.new({ :xmlid => params[:xmlid] }) if params.has_key?(:xmlid)
    @document = nil if @document && @document.token_count.blank?
  end

  # Set current group based on the current query or, if no query is selected, the GET parameters
  def set_grouping
    @group = @query && !@query.group.blank? ? @query.group : params[:group] || params[:listtype]
  end
  
  # Set current query
  def set_query
    view = params.has_key?(:view) ? params[:view].to_i : 8
    if (params.has_key?(:filter) || params.has_key?(:patt) || params.has_key?(:id)) && !action_name.eql?('treemap') && !action_name.eql?('bubble')
      if params.has_key?(:filter) && view == 8
        params[:group] = "hit:#{params[:listtype]}" if params.has_key?(:listtype) && ['word','pos','lemma'].include?(params[:listtype])
      end
      unless ['corpora','document'].include?(action_name)
        @query = Explore::Query.find_from_params(action_name, @user, query_create_params)
        unless ['download','export'].include?(action_name)
          if @query && @query.patt && (!@query.finished? || !@query.output) && !@query.failed?
            if @query.view == 4
              @query.running!
              @result = Document.growth(@query)
              @query.hit_count = @result[:hit_count]
              @query.document_count = @result[:document_count]
              @query.finished!
            else
              threaded = !action_name.eql?('result')
              @query.execute(threaded) if @query && !@query.running? && !@query.failed? && !@query.output
            end
          end
        end
      end
    end
  end
  
  private
  
  # Check allowed parameters for query creation
  def query_create_params
    params.permit(:_, :format, :patt, :id, :within, :filter, :view, :listtype, :size, :group, :sort, :order, :offset, :number, :input_page, :sample, :samplenum, :sampleseed, :gap_values_tsv)
  end
  
end