# Interface controller for pages under Search namespace
class Search::InterfaceController < InterfaceController
  include Search
  before_action :set_query
  before_action :set_advanced_field, :only => [:advanced_column, :advanced_box, :advanced_field]
  before_action :set_field_values, :only => [:advanced_column, :advanced_box, :advanced_field]
  
  # Redirect from /search to /search/expert (with CQL query) or /search/simple (without CQL query)
  def search
    if params.has_key?(:patt)
      redirect_to search_expert_path, :params => params
    else
      redirect_to search_simple_path
    end
  end
  
  def simple
    respond_to do |format|
      format.html
    end
  end
  
  def extended
    respond_to do |format|
      format.html
    end
  end
  
  def advanced
    respond_to do |format|
      format.html
    end
  end
  
  # Load column for Search Advanced interface
  def advanced_column
    respond_to do |format|
      format.js { render '/search/interface/advanced/column' }
    end
  end
  
  # Load box for Search Advanced interface
  def advanced_box
    respond_to do |format|
      format.js { render '/search/interface/advanced/box' }
    end
  end
  
  # Load field for Search Advanced interface
  def advanced_field
    respond_to do |format|
      format.js { render '/search/interface/advanced/field' }
    end
  end
  
  def expert
    respond_to do |format|
      format.html
    end
  end
  
  def document
    respond_to do |format|
      format.html
    end
  end
  
  protected
  
  # Set current query
  def set_query
    @query = Search::Query.find_from_params(action_name, @user.id, params) if params.has_key?(:patt)
    @result = @query.execute if @query && !@query.finished? && !@query.failed?
  end
  
  # Get field values from parameters
  def set_field_values
    @field_values = {
      :token_type => !params[:token_type] || !['word', 'lemma', 'pos', 'phonetic'].include?(params[:token_type]) ? 'word' : params[:token_type],
      :operator => !params[:operator] || !['is', 'not', 'starts', 'ends', 'contains', 'regex'].include?(params[:operator]) ? 'is' : params[:operator],
      :input => params[:input],
      :batch => params[:batch] && params[:batch].eql?('true') ? true : false,
      :sensitive => params[:sensitive] && params[:sensitive].eql?('true') ? true : false,
      :startsen => params[:startsen] && params[:startsen].eql?('true') ? true : false,
      :endsen => params[:endsen] && params[:endsen].eql?('true') ? true : false,
      :repeat_from => params[:repeat_from] ? params[:repeat_from].to_i : 1,
      :repeat_to => params[:repeat_to] ? params[:repeat_to].to_i : 1
    }
  end
  
  def set_advanced_field
    @field = {
      :column => params[:column] ? params[:column].to_i : 0,
      :box => params[:box] ? params[:box].to_i : 0,
      :field => params[:field] ? params[:field].to_i : 0
    }
  end
end