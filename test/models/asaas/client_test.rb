# == Schema Information
#
# Table name: asaas_clients
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :text             not null
#

require 'test_helper'

class Asaas::ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
