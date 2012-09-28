require 'test_helper'

class CiudadesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get nuevo" do
    get :nuevo
    assert_response :success
  end

  test "should get guardar" do
    get :guardar
    assert_response :success
  end

  test "should get editar" do
    get :editar
    assert_response :success
  end

  test "should get actualizar" do
    get :actualizar
    assert_response :success
  end

  test "should get eliminar" do
    get :eliminar
    assert_response :success
  end

end
