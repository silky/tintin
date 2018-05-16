module Tintin.Html.Templating where

import Lucid

import Tintin.Core
import qualified Tintin.Html.Style as Style
import qualified Tintin.Domain.Project as Project

import qualified Data.Text as Text


wrap :: Project.Info -> Project.Page -> Text
wrap info page =
  if (Project.filename page) == "index.html"
  then wrapHome info page
  else wrapPage info page


wrapPage :: Project.Info -> Project.Page -> Text
wrapPage info page = toText . renderText $ do
  tintinHeader info page
  body_ [class_ "tintin-fg-black tintin-bg-white"] $ do
    section_ [ id_ "content"] $ do
      div_ [id_ "wrapper", class_ "toggled"] $ do
        div_ [id_ "sidebar-wrapper", class_ $ "h-100 tintin-bg-" <> bgColorOf info] $ do
          div_ [ class_ "h-100 tintin-bg-70"] ( p_ "" )
          ul_ [ class_ "sidebar-nav"] $ do
            li_ [ class_ $ "sidebar-brand tintin-bg-" <> bgColorOf info] $ do
              a_ [href_ "index.html", class_ "tintin-fg-white"] $ do
                case Project.logoUrl info of
                  Nothing -> toHtml $ Project.name info
                  Just url -> img_ [src_ url]
            forM_ (filter (\p -> "index.html" /= Project.filename p ) (Project.pages info) ) $ \p -> do
              li_ $ do
                let classes =
                      if Project.title page == Project.title p
                      then "tintin-fg-active"
                      else "tintin-fg-disabled"
                a_ [href_ $ Project.filename p, class_ classes] $ do
                  ( toHtml $ Project.title p )

        nav_ [class_ "navbar navbar-expand-lg tintin-fg-white tintin-bg-darkgrey"] $ do
          a_ [id_ "menu-toggle", href_ "#menu-toggle"] $
            img_ [ src_ "https://png.icons8.com/material/49/ffffff/menu.png" ]

        div_ [id_ "page-content-wrapper"] $ do
          div_ [class_ "container"] $ do
            div_ [class_ "col"] $
              toHtmlRaw $ Project.content page
      tintinPostInit


wrapHome :: Project.Info -> Project.Page -> Text
wrapHome info page = toText . renderText $ do
  tintinHeader info page
  body_ [class_ "tintin-fg-black tintin-bg-white"] $ do

    div_ [class_ $ "tintin-navigation tintin-bg-" <> bgColorOf info] $ do
      div_ [class_ "cover-container d-flex p-3 mx-auto flex-column tintin-fg-white"] $ do
        a_ [href_ "https://theam.github.io/tintin"] $ do
          img_ [ src_ "../../../assets/logo.svg", class_ "watermark" ]
        main_ [role_ "main", class_ "masthead mb-auto"] $ do
          div_ [class_ "container"] $ do
            div_ [class_ "row align-items-center"] $ do
              div_ [class_ "col", id_ "header-container"] $ do
                case Project.logoUrl info of
                  Just url -> img_ [ src_ url, class_ "cover-heading" ]
                  Nothing -> h1_ [class_ "cover-heading"] $ toHtml (Project.name info)
                p_ [class_ "cover-heading-subtitle"] (toHtml $ Project.synopsis info)

      navbar

    section_ [ id_ "content"
             , data_ "aos" "fade-up"
             , data_ "aos-duration" "800"
             , data_ "aos-once" "true"
             ] $ do
      div_ [class_ "container"] $ do
        div_ [class_ "content"
             ] $
          div_ [] $ do
            toHtmlRaw $ Project.content page
    footer
    tintinPostInit
 where
  navbar =
    nav_ [ class_ "navbar navbar-expand-lg navbar-dark tintin-navbar"
         , style_ "width: 100%;"
         ] $ do
      div_ [ class_ "container" ] $ do
        div_ [class_ "collapse navbar-collapse", id_ "navbarSupportedContent"] $ do
          ul_ [class_ "navbar-nav mr-auto"] $ do
            li_ [class_ "nav-item active"] $
              a_ [class_ "nav-link active", href_ "/index.html"] "Home"
            let (page:_) = filter (\x -> "index.html" /= Project.filename x ) (Project.pages info)
            li_ [class_ "nav-item"] $
              a_ [class_ "nav-link", href_ (Project.filename page)] "Docs"
        div_ $
          ul_ [class_ "navbar-nav mr-sm-2"] $
            li_ [class_ "nav-item"] $
              a_ [class_ "nav-link", href_ "https://github.com/theam/tintin"] "View on GitHub"

  footer =
    footer_ [ class_ "tintin-bg-darkgrey tintin-fg-white"] $
      div_ [class_ "container"] $
        div_ [class_ "row"] $ do
          div_ [class_ "col"] $
            p_ [class_ "tintin-fg-lightgrey"] $ do
              "Developed by "
              a_ [href_ $ "https://github.com/" <> Project.githubAuthor info] (toHtml $ Project.githubAuthor info)
          div_ [class_ "col"] $
            p_ [class_ "tintin-fg-lightgrey float-right"] $ do
              "Built with "
              a_ [href_ "https://theam.github.io/tintin"] "tintin"


tintinHeader :: Project.Info -> Project.Page -> Html ()
tintinHeader (Project.Info {..}) (Project.Page {..}) =
  head_ $ do
    title_ ( toHtml $ name <> " - " <> title )
    link_ [ rel_ "stylesheet"
          , href_ "https://cdn.rawgit.com/michalsnik/aos/2.1.1/dist/aos.css"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://fonts.googleapis.com/css?family=IBM+Plex+Sans|Montserrat:500"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
          ]
    link_ [ rel_ "stylesheet"
          , href_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/tomorrow-night.min.css"
          ]
    link_ [ rel_ "shortcut icon"
          , href_ "https://github.com/theam/tintin/raw/design-fixes/assets/favicon-grey.ico"
          ]
    style_ Style.style


tintinPostInit :: Html ()
tintinPostInit = do
  script_ [ src_ "https://code.jquery.com/jquery-3.2.1.slim.min.js" ] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"] ( "" :: Text )
  script_ [ src_ "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"] ( "" :: Text )
  script_ [ src_ "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/languages/haskell.min.js"] ("" :: Text)
  script_ [ src_ "https://cdn.rawgit.com/icons8/bower-webicon/v0.10.7/jquery-webicon.min.js" ] ( "" :: Text )
  script_ "$(function() { AOS.init(); })"
  script_ [ src_ "https://cdn.rawgit.com/michalsnik/aos/2.1.1/dist/aos.js"] ("" :: Text)
  script_ "hljs.initHighlightingOnLoad()"
  script_ "$(function () {$(\"#menu-toggle\").click(function(e) {\
        \e.preventDefault();\
        \$(\"#wrapper\").toggleClass(\"toggled\");\
    \})});"


bgColorOf :: Project.Info -> Text
bgColorOf info =
  Project.color info
  |> show
  |> Text.toLower

