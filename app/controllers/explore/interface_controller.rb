# Interface controller for the Explore namespace. It defines the separate pages in the Explore namespace and inherits from the application interface controller and the Explore controller concern.
class Explore::InterfaceController < InterfaceController
  include WhitelabExplore
  before_action :set_page
  before_action :set_tab, :only => [:document]
  before_action :set_listtype_options, :only => [:statistics, :ngrams]
  before_action :check_query_import, :only => [:statistics, :ngrams]
  
  # Redirect from /explore to /explore/corpora
  def explore
    redirect_to explore_corpora_path
  end

  # Load the Explore Corpora page
  def corpora
    @option = params[:option] || CORPUS_TITLE_FIELD
    respond_to do |format|
      format.html
    end
  end

  # Load the Explore Statistics page
  def statistics
    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end

  # Load the Explore N-grams page
  def ngrams
    @size = params.has_key?(:size) ? params[:size].to_i : 5
    respond_to do |format|
      format.html
      format.json { render json: @data }
    end
  end

  # Load the Explore Document page
  def document
    respond_to do |format|
      flash[:error] = "Document '#{params[:xmlid]}' not found" if params.has_key?(:xmlid) && !params[:xmlid].blank? && !@document
      format.html
    end
  end
  
  protected
  
  # Get translated list type options
  def set_listtype_options
    @listtype = params[:listtype] || 'word'
    @listtype_options = []
    ['word', 'lemma', 'pos', 'phonetic'].each do |type|
      @listtype_options << [t(:"data_labels.keys.#{type}").capitalize, type]
    end
  end
  
  # Set current page
  def set_page
    @page = action_name
  end
end