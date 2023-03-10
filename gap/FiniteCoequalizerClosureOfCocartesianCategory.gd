# SPDX-License-Identifier: GPL-2.0-or-later
# FiniteCocompletion: Finite (co)product/(co)limit (co)completions
#
# Declarations
#

#! @Chapter Binary coequalizer closure

####################################
#
#! @Section GAP categories
#
####################################

#! @Description
#!  The &GAP; category of finite coequalizer closures of cocartesian categories.
DeclareCategory( "IsFiniteCoequalizerClosureOfCocartesianCategory",
        IsCapCategory );

#! @Description
#!  The &GAP; category of cells in the finite coequalizer closure of a cocartesian category.
DeclareCategory( "IsCellInFiniteCoequalizerClosureOfCocartesianCategory",
        IsCapCategoryCell );

#! @Description
#!  The &GAP; category of objects in the finite coequalizer closure of a cocartesian category.
DeclareCategory( "IsObjectInFiniteCoequalizerClosureOfCocartesianCategory",
        IsCellInFiniteCoequalizerClosureOfCocartesianCategory and IsCapCategoryObject  );

#! @Description
#!  The &GAP; category of morphisms in the finite coequalizer closure of a cocartesian category.
DeclareCategory( "IsMorphismInFiniteCoequalizerClosureOfCocartesianCategory",
        IsCellInFiniteCoequalizerClosureOfCocartesianCategory and IsCapCategoryMorphism );

####################################
#
#! @Section Global variables
#
####################################

if false then
#! The quiver generating the category of quivers
DeclareGlobalVariable( "QuiverOfCategoryOfQuivers" );
fi;

####################################
#
#! @Section Attributes
#
####################################

#! @Arguments quiver
DeclareAttribute( "DefiningCoequalizerPair",
        IsObjectInFiniteCoequalizerClosureOfCocartesianCategory );

#! @Arguments quiver_morphism
DeclareAttribute( "DefiningPairOfMorphismBetweenCoequalizerPairs",
        IsMorphismInFiniteCoequalizerClosureOfCocartesianCategory );

####################################
#
#! @Section Constructors
#
####################################

#! @Description
#!  Return the finite coequalizer closure of the coartesian category <A>cat</A>.
#! @Arguments cat
DeclareAttribute( "FiniteCoequalizerClosureOfCocartesianCategory",
        IsCapCategory );
