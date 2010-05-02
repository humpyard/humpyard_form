class ElementsController < ::ApplicationController
  def index
    @elements = Element.all
  end
  
  def new
    @element = Element.new
  end
  
  def create
    @element = Element.new params[:element]
    if @element.save
      render 'show'
    else
      render 'new'
    end
  end
  
  def edit
    @element = Element.find(params[:id])
  end
  
  def update
    @element = Element.find(params[:id])
    if @element.update_attributes params[:element]
      render 'show'
    else
      render 'edit'
    end
  end
  
  def show
    @element = Element.find(params[:id])
  end
  
  def destroy
    @element = Element.find(params[:id])
    @element.destroy
  end
end