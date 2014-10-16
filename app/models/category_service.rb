class CategoryService < ActiveRecord::Base
	has_many :sub_category_services
end
