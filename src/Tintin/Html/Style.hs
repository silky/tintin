module Tintin.Html.Style where

import Tintin.Core hiding (( & ), rem, (|>))

import Clay
import qualified Clay.Media as Media
import Clay.Selector

style :: Text
style = toText . render $ do
  html ? do
    minHeight (pct 100)

  body ? do
    fontFamily ["IBM Plex Sans"] [ sansSerif ]
    fontSize (em 1)
    overflowX hidden

  forM [h1, h2, h3] $ \x -> x ? do
    fontFamily ["Montserrat" ] [ sansSerif ]
    fontWeight bold

  h1 ? do
    fontSize (em 2.441)

  h2 ? do
    fontSize (em 1.953)

  h3 ? do
    fontSize (em 1.563)


  -- a ? do
  --   let ( ( _, colorValue ) : _ ) = Tintin.Core.filter (\x -> fst x == "lightblue") colorNames
  --   color colorValue
  --   ":hover" Clay.& color colorValue

  "#header-container" ? do
    marginTop (rem 5)
    marginBottom (rem 5)

  ".cover-heading" ? do
    fontSize (pct 800)
    maxHeight (rem 6)
    marginBottom (rem 1.563)

  ".cover-container" ? do
   backgroundColor (rgba 255 255 255 0.0)

  ".watermark" ? do
    position absolute
    top (px 0)
    left (px 0)
    maxHeight (rem 1.2504)
    marginTop (rem 1.2504)
    marginLeft (rem 1.2504)

  ".cover-heading-subtitle" ? do
    fontSize (rem 1.953)

  ".vertical-auto" ? do
    marginTop auto
    marginBottom auto

  ".content" ? do
    marginTop (pct 5)
    marginBottom (pct 5)

  "#wrapper" ? do
    paddingLeft (px 0)
    transition "all" (sec 0.5) ease (sec 0.5)
    ".toggled" & do
      paddingLeft (px 250)
      "#sidebar-wrapper" ? do
        width (px 250)
      "#page-content-wrapper" & do
        position absolute
        marginRight (px (-250))

  "#page-content-wrapper" ? do
    width (pct 100)
    position absolute
    padding (px 15) (px 15) (px 15) (px 15)

  "#sidebar-wrapper" ? do
    zIndex 1000
    position fixed
    left (px 250)
    width (px 0)
    marginLeft (px (-250))
    overflowY hidden
    overflowX hidden
    transition "all" (sec 0.5) ease (sec 0.5)


  ".sidebar-nav" ? do
    position absolute
    top (px 0)
    width (px 250)
    margin (px 0) (px 0) (px 0) (px 0)
    padding (px 0) (px 0) (px 0) (px 0)
    listStyleType none
    "li" ? do
      textIndent (indent $ px 20)
      lineHeight (px 40)
      "a" ? do
        display block
        textDecoration none
        fontWeight bold
        ":hover" & do
          textDecoration none
          color white
        ":active" & do
          textDecoration none
          color white
        ":focus" & do
          textDecoration none
          color white

  ".sidebar-nav" |> ".sidebar-brand" ? do
    height (px 65)
    fontSize (px 28)
    lineHeight (px 60)
    fontFamily ["Montserrat"] [sansSerif]
    fontWeight bold
    img ? do
      maxHeight (px 35)

  ".tintin-navbar" ? do
    fontWeight bold
    backgroundColor (rgba 255 255 255 0.15)

  ".tintin-bg-70" ? do
    backgroundColor (rgba 255 255 255 0.15)

  forM colorNames $ \(colorName, colorValue) ->
    (text $ ".tintin-bg-" <> colorName) ? do
      backgroundColor colorValue

  forM colorNames $ \(colorName, colorValue) ->
    (text $ ".tintin-fg-" <> colorName) ? do
      color colorValue

  ".tintin-fg-active" ? do
    color (rgba 255 255 255 1.0)

  ".tintin-fg-disabled" ? do
    color (rgba 255 255 255 0.35)

  footer ? do
    position relative
    bottom (px 0)
    left (px 0)
    width (pct 100)
    paddingTop (px 30)
    paddingBottom (px 30)

  ".container" ? do
    maxWidth (rem 50)

  query Media.screen [Media.minWidth (px 768)] $ do
    "#wrapper" ? do
      paddingLeft (px 0)
      ".toggled" ? do
        paddingLeft (px 250)
        "#sidebar-wrapper" ? do
          width (px 250)
        "#page-content-wrapper" ? do
          position relative
          marginRight (px 0)

    "#sidebar-wrapper" ? do
      width (px 0)

    "#page-content-wrapper" ? do
      padding (px 20) (px 20) (px 20) (px 20)
      position relative




colorNames :: [(Text, Color)]
colorNames =
  [ ("black"     , "#1d1f21")
  , ("white"     , "#f5f8f6")
  , ("grey"      , "#4D4D4D")
  , ("red"       , "#D30228")
  , ("darkgreen" , "#3C8B6A")
  , ("lightgreen", "#A4CB58")
  , ("darkorange", "#FF6602")
  , ("blue"      , "#94C1E8")
  , ("darkblue"  , "#007C99")
  , ("purple"    , "#9F76B4")
  , ("bronze"    , "#A4A27A")
  , ("darkgrey"  , "#282a2e")
  ]
