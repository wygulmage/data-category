{-# LANGUAGE TypeFamilies, MultiParamTypeClasses, GADTs, EmptyDataDecls, FlexibleInstances #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Data.Category.Boolean
-- Copyright   :  (c) Sjoerd Visscher 2010
-- License     :  BSD-style (see the file LICENSE)
--
-- Maintainer  :  sjoerd@w3future.com
-- Stability   :  experimental
-- Portability :  non-portable
--
-- /2/, or the Boolean category. 
-- It contains 2 objects, one for true and one for false.
-- It contains 3 arrows, 2 identity arrows and one from false to true.
-----------------------------------------------------------------------------
module Data.Category.Boolean where

import Prelude hiding ((.), id, Functor)

import Data.Category
import Data.Category.Limit


data BF
data BT
  
data Boolean a b where
  IdFls  :: Boolean BF BF
  FlsTru :: Boolean BF BT
  IdTru  :: Boolean BT BT

-- | @Boolean@ is the category with true and false as objects, and an arrow from false to true.
instance Category Boolean where
  data Obj Boolean a where
    Fls :: Obj Boolean BF
    Tru :: Obj Boolean BT
  
  src IdFls  = Fls
  src FlsTru = Fls
  src IdTru  = Tru
  
  tgt IdFls  = Fls
  tgt FlsTru = Tru
  tgt IdTru  = Tru
  
  id Fls     = IdFls
  id Tru     = IdTru
  
  IdFls  . IdFls  = IdFls
  FlsTru . IdFls  = FlsTru
  IdTru  . FlsTru = FlsTru
  IdTru  . IdTru  = IdTru
  _      . _      = error "Other combinations should not type check"


-- | False is the initial object in the Boolean category.
instance HasInitialObject Boolean where
  type InitialObject Boolean = BF
  initialObject = Fls
  initialize Fls = IdFls
  initialize Tru = FlsTru
  
-- | True is the terminal object in the Boolean category.
instance HasTerminalObject Boolean where
  type TerminalObject Boolean = BT
  terminalObject = Tru
  terminate Fls = FlsTru
  terminate Tru = IdTru


type instance BinaryProduct Boolean BF BF = BF
type instance BinaryProduct Boolean BF BT = BF
type instance BinaryProduct Boolean BT BF = BF
type instance BinaryProduct Boolean BT BT = BT

instance HasBinaryProducts Boolean where 
  
  product Fls Fls = Fls
  product Fls Tru = Fls
  product Tru Fls = Fls
  product Tru Tru = Tru
  
  proj1 Fls Fls = IdFls
  proj1 Fls Tru = IdFls
  proj1 Tru Fls = FlsTru
  proj1 Tru Tru = IdTru
  proj2 Fls Fls = IdFls
  proj2 Fls Tru = FlsTru
  proj2 Tru Fls = IdFls
  proj2 Tru Tru = IdTru
  
  IdFls  &&& IdFls  = IdFls
  IdFls  &&& FlsTru = IdFls
  FlsTru &&& IdFls  = IdFls
  FlsTru &&& FlsTru = FlsTru
  IdTru  &&& IdTru  = IdTru
  _      &&& _      = error "Other combinations should not type check"


type instance BinaryCoproduct Boolean BF BF = BF
type instance BinaryCoproduct Boolean BF BT = BT
type instance BinaryCoproduct Boolean BT BF = BT
type instance BinaryCoproduct Boolean BT BT = BT

instance HasBinaryCoproducts Boolean where 
  
  coproduct Fls Fls = Fls
  coproduct Fls Tru = Tru
  coproduct Tru Fls = Tru
  coproduct Tru Tru = Tru
  
  inj1 Fls Fls = IdFls
  inj1 Fls Tru = FlsTru
  inj1 Tru Fls = IdTru
  inj1 Tru Tru = IdTru
  inj2 Fls Fls = IdFls
  inj2 Fls Tru = IdTru
  inj2 Tru Fls = FlsTru
  inj2 Tru Tru = IdTru
    
  IdFls  ||| IdFls  = IdFls
  FlsTru ||| FlsTru = FlsTru
  FlsTru ||| IdTru  = IdTru
  IdTru  ||| FlsTru = IdTru
  IdTru  ||| IdTru  = IdTru
  _      ||| _      = error "Other combinations should not type check"


instance Show (Obj Boolean a) where
  show Fls = "Fls"
  show Tru = "Tru"