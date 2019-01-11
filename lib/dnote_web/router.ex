defmodule DnoteWeb.Router do
  use DnoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DnoteWeb.IdentifyUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DnoteWeb do
    pipe_through :browser

    get "/signup", AccountController, :new
    post "/signup", AccountController, :create
    get "/change_email", AccountController, :edit_email
    put "/change_email", AccountController, :update_email
    get "/change_password", AccountController, :edit_password
    put "/change_password", AccountController, :update_password

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :destroy

    get "/new", ArticleController, :new
    post "/new", ArticleController, :create
    get "/&:article", ArticleController, :show
    get "/&:article/edit", ArticleController, :edit

    get "/&:article/history", ReplicaController, :index
    get "/&:article/history/:replica", ReplicaController, :show

    get "/*keywords", ArticleController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", DnoteWeb do
  #   pipe_through :api
  # end
end
