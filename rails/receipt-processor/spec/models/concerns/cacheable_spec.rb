require 'rails_helper'


RSpec.describe Cacheable do

  it 'loads correctly' do
    expect(Cacheable).to be_a Module
  end

  let(:cacheable_class) { Class.new { include Cacheable } }

  describe '#create' do
    let(:string) { 'string_to_store'}

    it 'creates a random uuid and stores the string in redis' do
      uuid = cacheable_class.new.create(string)
      expect(REDIS.get(uuid)).to eq string
    end
  end

  describe '#find' do
    let(:string) { 'stored_string' }
    let(:uuid)   { cacheable_class.new.create(string) }


    it 'finds a stored string given the key' do
      REDIS.set(uuid, string)
      expect(cacheable_class.new.find(uuid)).to eq string
    end
  end

end