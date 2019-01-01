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

    get "/", HomeController, :index

    get "/$boards", BoardController, :index
    get "/$boards/new", BoardController, :new
    post "/$boards", BoardController, :create
    get "/~:board", BoardController, :show
    get "/~:board/edit", BoardController, :edit
    put "/~:board", BoardController, :update
    delete "/~:board", BoardController, :destroy

    get "/$labels", LabelController, :index
    get "/_labels", LabelController, :query
    get "/!:label", LabelController, :show

    get "/$articles", ArticleController, :index
    get "/$articles/new", ArticleController, :new
    get "/&:article", ArticleController, :show
    get "/&:article/edit", ArticleController, :edit

    get "/$journals", JournalController, :index
    get "/$journals/new", JournalController, :new
    get "/_:journal", JournalController, :edit
    post "/_:journal", JournalController, :update
    post "/_:journal/publish", JournalController, :publish
  end

  # Other scopes may use custom stacks.
  # scope "/api", DnoteWeb do
  #   pipe_through :api
  # end
end
