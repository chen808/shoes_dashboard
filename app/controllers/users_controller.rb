class UsersController < ApplicationController

	def show
		@user = User.find(params[:id]) #<----- Find the current user info by id and store info @user, send to views > users > show.html.erb
		@all_products = Product.all
	end

	def login
		@user = User.find_by_email(params[:email]) #<------ find user by email, if any, store into @user

		if @user && @user.authenticate(params[:password]) #<---- does user password match up?
			session[:user_id] = @user.id #<----- store user id to session (can be used later on)
			redirect_to '/users/%d' % session[:user_id] 
		else
			flash[:errors] = ["Invalid combination"] #<--- if validation fails, send error warning
			redirect_to :back
		end
	end

	def dashboard
		@user = User.find(params[:id])

		# find only the products from current user that are not sold yet
		@user_products = Product.where(seller:@user.first_name)

		@all_products = Product.all
	end

	def create
		# find the user name
		@current_user = User.find(params[:id])

		# create the new product with current user's name, product name and amount from 'dashboard.html.erb'
		@new_product = Product.create(product:params[:product], seller:@current_user.first_name, amount:params[:amount])

		# create a link in 'Sale' table. Attempting to use session for id, and instance variable (created above) for product
		Sale.create(user_id:params[:id], product_id:@new_product.id)

		redirect_to '/users/%d/dashboard' & session[:user_id]
	end

	def buy
		Buy.create(user_id:session[:user_id], product_id:params[:id])
		redirect_to :back

	end

	def destroy
		@product_to_destroy = Product.find(params[:id]) # find the prduct by incoming product id (from dashboard.html.erb)
		@product_to_destroy.destroy
		redirect_to :back
	end

end
