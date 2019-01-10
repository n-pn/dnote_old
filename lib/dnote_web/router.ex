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

    get "/", HomeController, :index

    get "/signup", AccountController, :new
    post "/signup", AccountController, :create
    get "/change_email", AccountController, :edit_email
    put "/change_email", AccountController, :update_email
    get "/change_password", AccountController, :edit_password
    put "/change_password", AccountController, :update_password

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :destroy

    get "/$labels", LabelController, :index
    get "/!:label", LabelController, :show

    get "/$boards", BoardController, :index
    get "/$boards/new", BoardController, :new
    post "/$boards", BoardController, :create
    get "/~:board", BoardController, :show
    get "/~:board/edit", BoardController, :edit
    put "/~:board/edit", BoardController, :update
    # get "/~:board/delete", BoardController, :delete
    # put "/~:board/delete", BoardController, :destroy

    get "/$articles", ArticleController, :index
    get "/$articles/new", ArticleController, :new
    post "/$articles/new", ArticleController, :create
    get "/&:article", ArticleController, :show
    get "/&:article/edit", ArticleController, :edit

    get "/$replicas", ReplicaController, :index
    get "/$replicas/new", ReplicaController, :new
    get "/_:replica", ReplicaController, :edit
    put "/_:replica", ReplicaController, :update
    post "/_:replica/publish", ReplicaController, :publish
  end

  # Other scopes may use custom stacks.
  # scope "/api", DnoteWeb do
  #   pipe_through :api
  # end
end
