# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/shops', type: :request do
  describe 'GET /index' do
    it 'return http success' do
      get api_v1_shops_url
      expect(response).to have_http_status(:success)
    end

    it 'returns all shops with associated schedules' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      shop = create(:shop)
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: shop)
      create(:schedule, day: 'Monday', opening_time: '14:00', closing_time: '19:00', shop: shop)
      shop2 = create(:shop)

      get api_v1_shops_url, as: :json
      json = JSON.parse(response.body)

      expect(json.size).to eq(2)
      expect(json[0]['name']).to eq(shop.name)
      expect(json[0]['sorted_schedules'].size).to eq(2)
      expect(json[1]['name']).to eq(shop2.name)
      expect(json[1]['sorted_schedules'].size).to eq(0)
    end
  end

  describe 'GET /show' do
    it 'return http success' do
      shop = create(:shop)
      get api_v1_shop_url(shop), as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns the shop with associated schedules' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      shop = create(:shop)
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: shop)
      create(:schedule, day: 'Monday', opening_time: '14:00', closing_time: '19:00', shop: shop)

      get api_v1_shop_url(shop), as: :json
      json = JSON.parse(response.body)

      expect(json['name']).to eq(shop.name)
      expect(json['sorted_schedules'].size).to eq(2)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        post api_v1_shops_url, params: {
          api_v1_shop: {
            name: 'Carrouf'
          }
        }, as: :json
      end

      it 'returns the name' do
        expect(response.body).to include('Carrouf')
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      before do
        post api_v1_shops_url, params: {
          api_v1_shop: {
            name: ''
          }
        }, as: :json
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a shop' do
        shop = Shop.find_by(name: '')
        expect(shop).to be_nil
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        shop = create(:shop)
        patch api_v1_shop_url(shop), params: {
          api_v1_shop: {
            name: 'UpdatedShopName'
          }
        }, as: :json
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated name' do
        expect(response.body).to include('UpdatedShopName')
      end
    end

    context 'with invalid parameters' do
      before do
        shop = create(:shop)
        patch api_v1_shop_url(shop), params: {
          api_v1_shop: {
            name: ''
          }
        }, as: :json
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested shop' do
      shop = create(:shop)
      expect { delete api_v1_shop_url(shop), as: :json }.to change(Shop, :count).by(-1)
    end

    it 'destroys associated schedules' do
      shop = create(:shop)
      create(:schedule, day: 'Monday', opening_time: '08:00', closing_time: '12:00', shop: shop)
      create(:schedule, day: 'Monday', opening_time: '14:00', closing_time: '19:00', shop: shop)

      expect { delete api_v1_shop_url(shop), as: :json }.to change(Schedule, :count).by(-2)
    end
  end
end
