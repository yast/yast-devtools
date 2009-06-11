
require "XXpkgXX"

class XXPkgXXController < ApplicationController

    # the user must be logged in
    before_filter :login_required

    # GET /XXpkgXX
    # GET /XXpkgXX.xml
    # GET /XXpkgXX.json
    def index
	# read all items
	# FIXME: use the correct permission ID according to XXPkgXX::find_all function
#	if !permission_check("org.opensuse.yast.modules.yapi.XXpkgXX.list")
#	    render ErrorResult.error(403, 1, "no permission") and return
#	end
# FIXME: ^^^^ uncomment this block!!

	@items = XXPkgXX.find_all
    
	respond_to do |format|
	    format.html { render :xml => @items, :location => "none" } #return xml only
	    format.xml  { render :xml => @items, :location => "none" }
	    format.json { render :json => @items.to_json, :location => "none" }
	end
    end

    # GET /XXpkgXX/id
    # GET /XXpkgXX/id.xml
    # GET /XXpkgXX/id.json
    # return properties of one item
    def show
	# FIXME: use the correct permission ID according to XXPkgXX::find function
#	if !permission_check("org.opensuse.yast.modules.yapi.XXpkgXX.get")
#	    render ErrorResult.error(403, 1, "no permission") and return
#	end
# FIXME: ^^^^ uncomment this block!!

	@item = XXPkgXX.new
	@item.id = params[:id]

	if !@item.find
	    render ErrorResult.error(404, 2, "item not found") and return
	end

	respond_to do |format|
	    format.html { render :xml => @item, :location => "none" } #return xml only
	    format.xml  { render :xml => @item, :location => "none" }
	    format.json { render :json => @item.to_json, :location => "none" }
	end
    end

    # POST /XXpkgXX
    # POST /XXpkgXX.xml
    # POST /XXpkgXX.json
    # create a new item
    def create
	@item = XXPkgXX.new

	# FIXME: use the correct permission ID according to XXPkgXX::add function
	if !permission_check("org.opensuse.yast.modules.yapi.XXpkgXX.add")
	    render ErrorResult.error(403, 1, "no permission") and return
	else
	    if !@item.update_attributes(params[:id])
		render ErrorResult.error(404, 2, "input error") and return
	    end

	    if !@item.id.blank?
		if !@item.add
		    render ErrorResult.error(404, 3, "adding share failed") and return
		end
	    else
		render ErrorResult.error(404, 4, "empty id") and return
	    end
	end

	respond_to do |format|
	    format.html { render :xml => @item, :location => "none" } #return xml only
	    format.xml  { render :xml => @item, :location => "none" }
	    format.json { render :json => @item.to_json, :location => "none" }
	end
    end

    # PUT /XXpkgXX/id
    # PUT /XXpkgXX/id.xml
    # PUT /XXpkgXX/id.json
    # update one item
    def update
	# FIXME: use the correct permission ID according to XXPkgXX::edit function
	if !permission_check("org.opensuse.yast.modules.yapi.XXpkgXX.edit")
	    render ErrorResult.error(403, 1, "no permission") and return
	end

	@item = XXPkgXX.find(params[:id][:id])

	render ErrorResult.error(403, 1, "share not found") and return if @item.properties.blank?

	if !@item.update_attributes(params[:id])
	    render ErrorResult.error(404, 2, "input error") and return
	end

	if !@item.edit
	    render ErrorResult.error(404, 3, "editing share failed") and return
	end

	respond_to do |format|
	    format.html { render :xml => @item, :location => "none" } #return xml only
	    format.xml  { render :xml => @item, :location => "none" }
	    format.json { render :json => @item.to_json, :location => "none" }
	end
    end

    # DELETE /XXpkgXX/id
    # DELETE /XXpkgXX/id.xml
    # DELETE /XXpkgXX/id.json
    # delete one item
    def destroy
	# FIXME: use the correct permission ID according to XXPkgXX::delete function
	if !permission_check("org.opensuse.yast.modules.yapi.XXpkgXX.delete")
	    render ErrorResult.error(403, 1, "no permission") and return
	end

	@item = XXPkgXX.new 	
	@item.id = params[:id]

	if !@item.delete
	    render ErrorResult.error(404, 2, "delete failed") and return
	end

	respond_to do |format|
	    format.html { render :xml => @item, :location => "none" } #return xml only
	    format.xml  { render :xml => @item, :location => "none" }
	    format.json { render :json => @item.to_json, :location => "none" }
	end
    end

end

