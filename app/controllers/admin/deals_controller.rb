class Admin::DealsController < ApplicationController

  def index
    params[:search] = {} unless params[:search].present?
    @search = Deal.new
    @breadcrumb = {'Home' => home_url, 'Deals' => ''}
    @deals = Deal.search(params[:search])
    @deals = @deals.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  def create
    @deal = Deal.create!(deal_params)
    flash[:success] = "Successfully Added Deal"
    redirect_to admin_deals_path
  end

  def new
    @breadcrumb = {'Home' => home_url, 'Deals' => '/admin/deals', 'Create new deal' =>""}
    @new_deal=Deal.new
  end

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

  def deal_attributes
     if eval("#{params[:category].camelcase}DealAttribute").find_by_deal_id(params[:deal_id]).present?
       @table_data = eval("#{params[:category].camelcase}DealAttribute").where(:deal_id => params[:deal_id])
     end
    @table_data = [] if @table_data.blank?
    @table_data = @table_data.paginate(:page => params[:page], :per_page => PER_PAGE)
    @breadcrumb = {'Home' => home_url,"Deal" => admin_deals_path  ,'Deal Attributes' => ''}
    @deal=Deal.find(params[:deal_id])
  end

  #common function to add or edit
  def update_deal_attributes
    if eval("#{params[:category_name].camelcase}DealAttribute").exists? (params[:deal_attributes][:id])
      eval("#{params[:category_name].camelcase}DealAttribute").find(params[:deal_attributes][:id]).update(deal_attributes_params)
      flash[:success] = "Attribute Updated"
    else
      eval("#{params[:category_name].camelcase}DealAttribute").create!(deal_attributes_params)
      flash[:success] = "Attribute Added"
    end
    # redirect_to "/admin/deals/deal_attributes?category=#{params[:category_name]}&deal_id=#{params[:deal_attributes][:deal_id]}"
    # redirect_to :controller => "admin/deals", :action => "deal_attributes",:category=>params[:category_name],:deal_id=>params[:deal_attributes][:deal_id]
    redirect_to :back
  end
  # 
  # def view_all_deal_attributes
  #   @deal=Deal.find(params[:deal_id])
  #   @category_name = params[:category]
  #   @all_deal_attributes = @deal.internet_deal_attributes if @category_name == ServiceCategory::INTERNET_CATEGORY
  #   @all_deal_attributes = @deal.cable_deal_attributes if @category_name == ServiceCategory::CABLE_CATEGORY
  #   @all_deal_attributes = @deal.cellphone_deal_attributes if @category_name == ServiceCategory::CELLPHONE_CATEGORY
  #   @all_deal_attributes = @deal.telephone_deal_attributes if @category_name == ServiceCategory::TELEPHONE_CATEGORY
  #   @all_deal_attributes = @deal.bundle_deal_attributes if @category_name == ServiceCategory::BUNDLE_CATEGORY
  #   @breadcrumb = {'Home' => home_url,"Deal" => admin_deals_path  ,'Edit Deal Attribute' => ''}
  #   @all_deal_attributes.paginate(:page => params[:page], :per_page => PER_PAGE)
  #   @all_deal_attributes=[] if @all_deal_attributes.blank?
  #
  # end
  #
  # def edit_deal_attribute
  #   @deal=Deal.find(params[:deal_id])
  #   @category_name = params[:category]
  #   @deal_attribute_data = InternetDealAttribute.find(params[:attribute_id]) if @category_name == ServiceCategory::INTERNET_CATEGORY
  #   @deal_attribute_data = CellphoneDealAttribute.find(params[:attribute_id]) if @category_name == ServiceCategory::CELLPHONE_CATEGORY
  #   @deal_attribute_data = TelephoneDealAttribute.find(params[:attribute_id]) if @category_name == ServiceCategory::TELEPHONE_CATEGORY
  #   @deal_attribute_data = CableDealAttribute.find(params[:attribute_id]) if @category_name == ServiceCategory::CABLE_CATEGORY
  #   @deal_attribute_data = BundleDealAttribute.find(params[:attribute_id]) if @category_name == ServiceCategory::BUNDLE_CATEGORY
  #   @breadcrumb = {'Home' => home_url,"Deal" => admin_deals_path  ,'View Deal Attributes' => ''}
  # end

end

private

def deal_params
  params.require(:deal).permit!
end

def deal_attributes_params
  params.require(:deal_attributes).permit!
end