module NamedUselessSpec (main, spec) where

import Test.Hspec
import NamedLambdas
import NamedUseless

import Parser (ps)

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "bvrename" $ do
    it "can rename direct bound term" $ do
      bvrename (ps "lambda x (xy)") "x" "z" `shouldBe` (ps "lambda z (zy)")

    it "can rename direct unbound term" $ do
      bvrename (ps "lambda x (xy)") "y" "z" `shouldBe` (ps "lambda x (xy)")

    it "can rename variable in both bound and unbound contexts" $ do
      bvrename (ps "x (lambda x (xy))") "x" "z" `shouldBe` (ps "x (lambda z (zy))")

    it "works on Zvezdi's example" $ do
      bvrename (ps "λz λy zy") "y" "z" `shouldBe` (ps "λx λz xz")

  describe "substitute" $ do
    it "can substitute on the example from the PDF" $ do
      substitute (ps "y (lambda x (xyz)) z") "y" (ps "zy")
      `shouldBe`
      (ps "zy (lambda x (x(zy)z)) z")
    it "can substitute when there's a clash of variables" $ do
      substitute (ps "y (lambda x (xyz)) z") "y" (ps "zx")
      `shouldBe`
      (ps "zx (lambda t (t(zx)z)) z")