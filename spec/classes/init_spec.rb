require 'spec_helper'
describe 'create_user' do

  context 'with defaults for all parameters' do
    it { should contain_class('create_user') }
  end
end
