open import Data.Bool

module GUI.GUIExampleVers2   where

-- open import GUIgeneric.Prelude renaming (inj₁ to secondBtn; inj₂ to firstBtn)

-- open import GUIgeneric.PreludeGUI renaming (WxColor to Color) hiding ( _>>_)

open import StateSizedIO.GUI.BaseStateDependent
open import StateSizedIO.writingOOsUsingIOVers4ReaderMethods hiding (nˢ) renaming(execˢⁱ to execᵢ ; returnˢⁱ to returnᵢ)
open import GUI.GUIDefinitionsVers2
open import SizedIO.Base renaming (IO to IO∞; IO' to IO) hiding (_>>_)
open import SizedIO.Console

open import Data.String
open import GUI.GUIExampleLibVers2

open import Data.Fin

open import Size
open import Data.Unit
open import Data.Product

-- TODO later Properties of Buttons?
--

oneBtnFrame : Frame
oneBtnFrame = addButton "OK" emptyFrame

twoBtnFrame : Frame
twoBtnFrame = addButton "Cancel" oneBtnFrame


putStrLine' : {A : Set} → String → (f : IO∞ consoleI ∞ A) →
           IO consoleI ∞ A
putStrLine' s f = exec' (putStrLn s) (λ _ → f)

syntax putStrLine' s f = putStrLine s >> f




mutual
 obj2Btnaux : {i : Size} → GUI {i}
 obj2Btnaux .gui = oneBtnFrame
 obj2Btnaux .method = obj1Btn


 obj2Btn : ∀ {i} → GUIObj {i} twoBtnFrame
 obj2Btn {i} {j} (zero , _ ) = putStrLine "OK! Redefining GUI." >>
                        return (obj2Btnaux {j})
 obj2Btn {i} {j} (suc zero , _) = putStrLine "Cancel." >>
                          return (obj2Btnaux {j})



{-
--
-- CORRECT:
--
--

 obj2Btn .method (suc zero) = putStrLine "Cancel! No change." >>
                              return (twoBtnFrame , obj2Btn)
-}
 obj2Btn (suc (suc ()) , _)


 obj1Btn : ∀ {i} → GUIObj {i} oneBtnFrame
 obj1Btn (zero , _ )  = putStrLine "OK! Redefining GUI." >>
                        return obj2Btnaux
 obj1Btn (suc () , _)



mutual
  oneBtnGUI : ∀ {i} → GUI {i}
  oneBtnGUI .gui = addButton "OK" emptyFrame
  oneBtnGUI .method (zero , _ )  = putStrLine "OK! Redefining GUI." >>
                                        return twoBtnGUI
  oneBtnGUI .method (suc () , _ )


  twoBtnGUI : ∀ {i} → GUI {i}
  twoBtnGUI .gui = addButton "Cancel" (addButton "OK" emptyFrame)
  twoBtnGUI .method (zero , _ ) = putStrLine "OK! Redefining GUI." >>
                                     return oneBtnGUI
  twoBtnGUI .method (suc zero , _) = putStrLine "Cancel." >>
                              return twoBtnGUI
  twoBtnGUI .method (suc (suc ()) , _)

-- GUIObj


{-
Not yet supported:
addTxtBox : String → Frame → Frame
addTxtBox str fr = addTxtBox' str fr optimized
-}

{-
Attributes/Properties not yet supported:
-- Attributes
--
Cols = ℕ
Margin  = ℕ
HSpace  = ℕ
VSpace  = ℕ

-
oneColumnLayout : Cols × Margin × HSpace × VSpace
oneColumnLayout = (1 , 10 , 2 , 2)
-



-
black : Color
-
black = rgb 0 0 0

-
propOneBtn : properties oneBtnFrame
propOneBtn = black , oneColumnLayout
-

-
propTwoBtn : properties twoBtnFrame
propTwoBtn = black , black , oneColumnLayout
-
-}

{-
Doesn't make sense any longer. We always change the GUI currently!
keepGUI : {j : Size} → HandlerObject j twoBtnFrame →
            IO consoleI ∞
      (Σ-syntax (returnType twoBtnFrame)
       (λ r →
          IOObjectˢ consoleI handlerInterface j
          (nextStateFrame twoBtnFrame r)))
keepGUI = λ obj → return (noChange , obj)


changeGUI : ∀ {j} (g : CompEls frame) {g'} (prop : properties g) obj →
              IO consoleI ∞ (Σ (returnType g') (\r -> IOObjectˢ consoleI handlerInterface j (nextStateFrame g' r)))
changeGUI = λ g prop obj →  return (changedGUI g prop , obj)
-}




{- ######
compileProg : ∀ (a : CompEls frame) (b : properties a)
             (c : {i : Size} → GUIObj {i} a) → NativeIO Unit
compileProg = λ a b c →  compileProgram a b (c {∞})

-
main : NativeIO Unit
main = compileProg twoBtnFrame propTwoBtn obj2Btn
-

--old
--main : NativeIO Unit
--main = compileProgram  twoBtnFrame propTwoBtn
--                       (obj2Btn {∞})
###-}
