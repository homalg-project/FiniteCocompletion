#! @Chunk SkeletalHomStructure

#! @Example
LoadPackage( "FiniteCocompletion" );
#! true
sFinSets := SkeletalFinSetsAsFiniteCoproductCocompletionOfTerminalCategory( );
#! SkeletalFinSetsAsFiniteCoproductCocompletionOfTerminalCategory
A := ObjectConstructor( sFinSets, 3 );
#! |3|
B := ObjectConstructor( sFinSets, 2 );
#! |2|
HomAB := HomStructure( A, B );
#! |8|
I := HomStructure( sFinSets );
#! |1|
homAB := List( [ 0 .. Length( L ) - 1 ], i ->
               MorphismConstructor( I, [ i ], HomAB ) );
#! [ |1| → |8|, |1| → |8|, |1| → |8|, |1| → |8|,
#!   |1| → |8|, |1| → |8|, |1| → |8|, |1| → |8| ]
List( homAB, IsWellDefined );
#! [ true, true, true, true, true, true, true, true ]
List( homAB, m -> HomStructure( HomStructure( A, B, m ) ) ) = homAB;
#! true
#! @EndExample