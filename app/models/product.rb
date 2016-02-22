class Product < ActiveRecord::Base
	belongs_to :sale
	belongs_to :buy
end
