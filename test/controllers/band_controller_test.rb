require 'test_helper'

class BandControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get band_index_url
    assert_response :success
  end

  test 'should get new' do
    get band_new_url
    assert_response :success
  end

  test 'should get create' do
    get band_create_url
    assert_response :success
  end

  test 'should get listing' do
    get band_listing_url
    assert_response :success
  end

  test 'should get social_media' do
    get band_social_media_url
    assert_response :success
  end

  test 'should get description' do
    get band_description_url
    assert_response :success
  end

  test 'should get band_pic_upload' do
    get band_band_pic_upload_url
    assert_response :success
  end

  test 'should get location' do
    get band_location_url
    assert_response :success
  end

  test 'should get update' do
    get band_update_url
    assert_response :success
  end
end
