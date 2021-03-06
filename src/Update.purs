module Update where

import Prelude ( Unit()
               , (#), ($), (>)
               , bind, return, unit )

import Control.Monad.Eff ( Eff() )
import Control.Monad.ST ( ST(), STRef()
                        , modifySTRef, readSTRef )
import Data.Array ( filter )
import Optic.Core ( (^.), (.~) )

import qualified Entities.Bullet as B
import qualified Entities.Game as G
import qualified Motion as M

-- import Control.Monad.Eff.Console ( CONSOLE() )
-- import Control.Monad.Eff.Console.Unsafe ( logAny )

removeOffscreenPlayerBullets :: forall eff g. STRef g G.Game
                             -> Eff ( st :: ST g | eff ) G.Game
removeOffscreenPlayerBullets gRef = do
  g <- readSTRef gRef
  let playerBullets = g ^. G.playerBullets
      newPlayerBullets = filter (\b -> b ^. B.y > -10.0) playerBullets
  modifySTRef gRef (\g -> g # G.playerBullets .~ newPlayerBullets)

update :: forall eff g. STRef g G.Game
       -> Eff ( st :: ST g
              -- , console :: CONSOLE
              | eff ) Unit
update gRef = do
  M.movePlayerBullets gRef
  removeOffscreenPlayerBullets gRef
  return unit
