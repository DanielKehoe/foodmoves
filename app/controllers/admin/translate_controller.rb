class Admin::TranslateController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(admin | manager | support)'

  def index
    @page_title = "Translating from #{Locale.base_language} to #{Locale.language.english_name}"
    @view_translations = ViewTranslation.find(:all, :conditions => [ 'language_id = ?', Locale.language.id ], :order => 'id desc')
  end

  def create
    from = params[:view][:text]
    singular = params[:view][:singular_form]
    plural = params[:view][:plural_form]
    if (plural.empty? && !singular.empty? && !from.empty?)
      Locale.set_pluralized_translation(from, 1, singular)
      flash[:notice] = "Translated '#{from}' to '#{singular}'"
    elsif(!plural.empty? && !singular.empty? && !from.empty?)
      Locale.set_translation(from, Locale.language, singular, plural)
      flash[:notice] = "Translated '#{from}' to singular '#{singular}' and plural '#{plural}'"
    else
      flash[:notice] = "Please specify singular and/or plural form for the translation"
    end
    redirect_to :controller => 'translate', :action => 'index'
  end

  def get_translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""
  end

  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value]
    @translation.text = prevous unless @translation.save
    render :text => @translation.text || '[no translation]'
  end

  def destroy
    ViewTranslation.find(params[:id]).destroy
    render :update do |page|
      page.remove("row_#{params[:id]}")
    end
  end
end