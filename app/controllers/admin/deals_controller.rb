class Admin::DealsController < ApplicationController

  def index
    params[:search] = {} unless params[:search].present?
    @search = Deal.new
    @breadcrumb = {'Home' => home_url, 'Deals' => ''}
    @deals = Deal.search(params[:search])
    @deals = @deals.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  # def create_deal
  #   @breadcrumb = {'Home' => home_url, 'Deals' => '/admin/deals', 'Create new deal' =>""}
  #   @new_deal=Deal.new
  #  end
  #
  # def create_new_deal
  # end
  def show
  end

  def destroy
    @deal = Deal.find(params[:id])
    respond_to do |format|
        if @deal.destroy
          format.html { redirect_to admin_deals_path, :notice => 'You have successfully removed a deal' }
          format.xml  { render :xml => @deal, :status => :created, :deal => @deal }
        end
  end
end
  #   # Deal.find(params[:id]).destroy
  #   flash[:success] = "Deleted"
  #   redirect_to :back
  # end

  def edit
    @breadcrumb = {'Home' => home_url, 'Deals' => '/admin/deals', 'Edit Deal' =>""}
    @deal_details = Deal.find(params[:id])
  end

   def update
       @deal = Deal.find(params[:id])
       if @deal.update(deal_params)
         flash[:success] = "Successfully updated"
       else
         flash[:danger] = "Error updating deal"
       end
      redirect_to :back
   end
end

private

def deal_params
  params.require(:deal).permit!
end
