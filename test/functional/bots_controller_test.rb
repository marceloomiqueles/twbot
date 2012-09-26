require 'test_helper'

class BotsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get nuevo" do
    get :nuevo
    assert_response :success
  end

  test "should get editar" do
    get :editar
    assert_response :success
  end

  test "should get agregar_palabras" do
    get :agregar_palabras
    assert_response :success
  end

end
