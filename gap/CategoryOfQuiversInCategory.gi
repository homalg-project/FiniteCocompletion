# SPDX-License-Identifier: GPL-2.0-or-later
# FiniteCocompletion: Finite (co)product/(co)limit (co)completions
#
# Implementations
#

##
InstallOtherMethodForCompilerForCAP( CreateQuiverInCategory,
        "for a category of quivers in a category and a pair",
        [ IsCategoryOfQuiversInCategory, IsList ],
        
  function ( category_of_quivers, pair )
    
    #% CAP_JIT_DROP_NEXT_STATEMENT
    Assert( 0,
            Length( pair ) = 2 and
            IsList( pair[1] ) and
            ForAll( pair[1], IsCapCategoryObject ) and
            IsList( pair[2] ) and
            ForAll( pair[2], IsList ) and
            ForAll( pair[2], e -> IsInt( e[1] ) and IsInt( e[3] ) ) and
            ForAll( pair[2], e -> IsCapCategoryMorphism( e[2] ) ) );
    
    return CreateCapCategoryObjectWithAttributes( category_of_quivers,
                   DefiningPairOfQuiverInCategory, pair );
    
end );

##
InstallOtherMethodForCompilerForCAP( CreateQuiverMorphismInCategory,
        "for a category of quivers, two objects in a category of quivers, and a pair",
        [ IsCategoryOfQuiversInCategory, IsObjectInCategoryOfQuiversInCategory, IsList, IsObjectInCategoryOfQuiversInCategory ],
        
  function ( category_of_quivers, source, images, range )
    
    return CreateCapCategoryMorphismWithAttributes( category_of_quivers,
                   source,
                   range,
                   DefiningPairOfQuiverMorphismInCategory, images );
    
end );

##
InstallMethod( CategoryOfQuivers,
        "for a category",
        [ IsCapCategory ],
        
  function ( C )
    local object_constructor, object_datum,
          morphism_constructor, morphism_datum,
          F, UC, Coeq,
          modeling_tower_object_constructor, modeling_tower_object_datum,
          modeling_tower_morphism_constructor, modeling_tower_morphism_datum,
          Quivers;
    
    ##
    object_constructor := CreateQuiverInCategory;
    
    ##
    object_datum := { Quivers, o } -> DefiningPairOfQuiverInCategory( o );
    
    ##
    morphism_constructor := CreateQuiverMorphismInCategory;
    
    ##
    morphism_datum := { Quivers, m } -> DefiningPairOfQuiverMorphismInCategory( m );
    
    ## building the categorical tower:
    F := FreeCategory( QuiverOfCategoryOfQuivers : range_of_HomStructure := SkeletalFinSets, FinalizeCategory := true );
    
    F := CategoryFromDataTables( F : FinalizeCategory := true );
    
    UC := FiniteStrictCoproductCocompletion( C : FinalizeCategory := true );

    Coeq := FiniteCoequalizerClosureOfCocartesianCategory( UC : FinalizeCategory := true );
    
    ## from the raw object data to the object in the modeling category
    modeling_tower_object_constructor :=
      function( Quivers, pair )
        local Coeq, PSh, UC, C, objects, decorated_morphisms, V, A, map_s, mor_s, s, map_t, mor_t, t;
        
        Coeq := ModelingCategory( Quivers );
        
        PSh := ModelingCategory( Coeq );
        
        UC := Range( PSh );
        
        C := UnderlyingCategory( UC );
        
        objects := pair[1];
        decorated_morphisms := pair[2];
        
        V := ObjectConstructor( UC,
                     Pair( Length( objects ), objects ) );
        
        A := ObjectConstructor( UC,
                     Pair( Length( decorated_morphisms ),
                           List( decorated_morphisms, m -> objects[1 + m[1]] ) ) );
        
        map_s := List( decorated_morphisms, m -> m[1] );
        
        mor_s := List( decorated_morphisms, m -> IdentityMorphism( C, objects[1 + m[1]] ) );
        
        s := MorphismConstructor( UC,
                     A,
                     Pair( map_s, mor_s ),
                     V );
        
        map_t := List( decorated_morphisms, m -> m[3] );
        
        mor_t := List( decorated_morphisms, m -> m[2] );
        
        t := MorphismConstructor( UC,
                     A,
                     Pair( map_t, mor_t ),
                     V );
        
        return ObjectConstructor( Coeq, Pair( s, t ) );
        
    end;
    
    ## from the object in the modeling category to the raw object data
    modeling_tower_object_datum :=
      function( Quivers, obj )
        local Coeq, PSh, UC, pair, s, t, V, objects, s_datum, t_datum, decorated_morphisms;
        
        Coeq := ModelingCategory( Quivers );
        
        PSh := ModelingCategory( Coeq );
        
        UC := Range( PSh );
        
        pair := ObjectDatum( Coeq, obj );
        
        s := pair[1];
        t := pair[2];
        
        V := Range( s );
        
        objects := ObjectDatum( UC, V )[2];
        
        s_datum := MorphismDatum( UC, s );
        t_datum := MorphismDatum( UC, t );
        
        decorated_morphisms := ListN( s_datum[1],
                                      t_datum[2],
                                      t_datum[1],
                                      { s_index, mor, t_index } -> Triple( s_index, mor, t_index ) );
        
        return Pair( objects, decorated_morphisms );
        
    end;
    
    ## from the raw morphism data to the morphism in the modeling category
    modeling_tower_morphism_constructor :=
      function( Quivers, source, images, range )
        local Coeq, PSh, UC, source_datum, range_datum, V, source_s_datum, A;
        
        Coeq := ModelingCategory( Quivers );
        
        PSh := ModelingCategory( Coeq );
        
        UC := Range( PSh );
        
        source_datum := ObjectDatum( Coeq, source );
        range_datum := ObjectDatum( Coeq, range );
        
        V := MorphismConstructor( UC,
                     Range( source_datum[1] ),
                     images[1],
                     Range( range_datum[1] ) );
        
        source_s_datum := MorphismDatum( UC, source_datum[1] );
        
        A := MorphismConstructor( UC,
                     Source( source_datum[1] ),
                     Pair( images[2],
                           source_s_datum[2] ),
                     Source( range_datum[1] ) );
        
        return MorphismConstructor( Coeq,
                       source,
                       Pair( V, A ),
                       range );
        
    end;
    
    ## from the morphism in the modeling category to the raw morphism data
    modeling_tower_morphism_datum :=
      function( Quivers, mor )
        local Coeq, PSh, UC, mor_datum, V_datum, A_datum;
        
        Coeq := ModelingCategory( Quivers );
        
        PSh := ModelingCategory( Coeq );
        
        UC := Range( PSh );
        
        mor_datum := MorphismDatum( Coeq, mor );
        
        V_datum := MorphismDatum( UC, mor_datum[1] );
        A_datum := MorphismDatum( UC, mor_datum[2] );
        
        return Pair( V_datum, A_datum[1] );
        
    end;
    
    ## the wrapper category interacts with the user through the raw data but uses
    ## the tower to derive the algorithms turning the category into a constructive topos;
    ## after compilation the tower is gone and the only reminiscent which hints to the tower
    ## is the attribute ModelingCategory:
    Quivers := WrapperCategory( Coeq,
                       rec( name := Concatenation( "CategoryOfQuivers( ", Name( C ), " )" ),
                            category_filter := IsCategoryOfQuiversInCategory,
                            category_object_filter := IsObjectInCategoryOfQuiversInCategory,
                            category_morphism_filter := IsMorphismInCategoryOfQuiversInCategory,
                            object_constructor := object_constructor,
                            object_datum := object_datum,
                            morphism_datum := morphism_datum,
                            morphism_constructor := morphism_constructor,
                            modeling_tower_object_constructor := modeling_tower_object_constructor,
                            modeling_tower_object_datum := modeling_tower_object_datum,
                            modeling_tower_morphism_constructor := modeling_tower_morphism_constructor,
                            modeling_tower_morphism_datum := modeling_tower_morphism_datum,
                            only_primitive_operations := true )
                       : FinalizeCategory := false );
    
    SetUnderlyingCategory( Quivers, C );
    
    Quivers!.compiler_hints.category_attribute_names :=
           [ "ModelingCategory",
            ];
    
    if ValueOption( "no_precompiled_code" ) <> true then
        
    fi;
    
    Finalize( Quivers );
    
    return Quivers;
    
end );

####################################
#
# View, Print, Display and LaTeX methods:
#
####################################

##
InstallMethod( Display,
        "for an object in a category of quivers in a category",
        [ IsObjectInCategoryOfQuiversInCategory ],
        
  function ( quiver )
    
    Display( ObjectDatum( quiver ) );
    
    Print( "\nAn object in ", Name( CapCategory( quiver ) ), " given by the above data\n" );
    
end );

##
InstallMethod( Display,
        "for a morphism in a category of quivers in a category",
        [ IsMorphismInCategoryOfQuiversInCategory ],
        
  function ( quiver_morphism )

    Print( "Source: " );
    Display( Source( quiver_morphism ) );
    Print( "\nDatum:  " );
    Display( MorphismDatum( quiver_morphism ) );
    Print( "\nRange:  " );
    Display( Range( quiver_morphism ) );
    
    Print( "\nA morphism in ", Name( CapCategory( quiver_morphism ) ), " given by the above data\n" );
    
end );
