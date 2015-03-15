class Invitation < ActiveRecord::Base
  TYPE = ['approved', 'pending', 'rejected']
end
