defmodule Bonfire.AI.Web.Routes do
  def declare_routes, do: nil

  defmacro __using__(_) do
    quote do
      # pages anyone can view
      scope "/ai/", Bonfire.AI.Web do
        pipe_through(:browser)

        live("/", HomeLive)
        live("/about", AboutLive)
      end

      # pages only guests can view
      scope "/ai/", Bonfire.AI.Web do
        pipe_through(:browser)
        pipe_through(:guest_only)
      end

      # pages you need an account to view
      scope "/ai/", Bonfire.AI.Web do
        pipe_through(:browser)
        pipe_through(:account_required)
      end

      # pages you need to view as a user
      scope "/ai/", Bonfire.AI.Web do
        pipe_through(:browser)
        pipe_through(:user_required)
      end

      # pages only admins can view
      scope "/ai/admin", Bonfire.AI.Web do
        pipe_through(:browser)
        pipe_through(:admin_required)
      end
    end
  end
end
