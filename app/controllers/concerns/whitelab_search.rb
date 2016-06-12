module WhitelabSearch
  extend ActiveSupport::Concern

  included do
    before_filter :set_query
    before_filter :set_document
    before_filter :set_grouping
    before_filter :set_filter
    before_filter :set_filtered_amount
  end
  
  protected
  
  # Get grouping options for grouped hits or documents, depending on selected view
  def set_grouping
    if @query && [8,16].include?(@query.view) && ['simple', 'extended', 'advanced', 'expert', 'result'].include?(action_name)
      group = @query.group || params[:group]
      @groups = @metadata_handler.get_group_options(@query.view, 'search')
      if !group.blank?
        @group = group.gsub(/ /,"_")
      end
    end
  end
  
  # Set current document
  def set_document
    patt = params[:patt]
    patt = @user.search_queries.find(params[:id]).patt if !patt && params.has_key?(:id)
    @document = Document.new({ :xmlid => params[:xmlid], :patt => patt }) if params.has_key?(:xmlid)
    @document = nil if @document && @document.token_count.blank?
  end
  
  # Set current query
  def set_query
    @query = Search::Query.find_from_params(action_name, @user, query_create_params) if params.has_key?(:patt) || params.has_key?(:id)
    p @query
    @query.execute if @query && @query.waiting?
  end
  
  private
  
  # Check allowed parameters for query creation
  def query_create_params
    params.permit(:patt, :id, :within, :filter, :view, :group, :sort, :order, :offset, :number, :input_page)
  end
  
end