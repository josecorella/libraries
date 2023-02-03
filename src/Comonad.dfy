include "Functor.dfy"
include "Cowrappers.dfy"

abstract module {:options "-functionSyntax:4"} Comonad refines Functor {
  /* Structure  */
  type W(!new)<T(!new)>

  function Extract<T(!new)>(w: W<T>): T

  function Duplicate<T(!new)>(w: W<T>): W<W<T>>

  /* Naturality of Extract and Duplicate */
  lemma LemmaExtractNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>)
    requires EquivalenceRelation(eq)
    ensures eq(f(Extract(w)), Extract(Map(f)(w)))

  lemma LemmaDuplicateNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>)
    requires EquivalenceRelation(eq)
    ensures EquivalenceRelation(Equal(eq))
    ensures Equal(Equal(eq))(Duplicate(Map(f)(w)), Map(Map(f))(Duplicate(w)))

  /* Comonad laws */
  lemma LemmaCoUnitalityExtract<T(!new)>(eq: (T, T) -> bool, w: W<T>)
    requires EquivalenceRelation(eq)
    ensures && Equal(eq)(Map(Extract)(Duplicate(w)), w)
            && Equal(eq)(w, Extract(Duplicate(w)))
 
  lemma LemmaCoAssociativityDuplicate<T(!new)>(eq: (T, T) -> bool, w: W<T>) 
    requires && EquivalenceRelation(eq)
             && EquivalenceRelation(Equal(eq))
             && EquivalenceRelation(Equal(Equal(eq))) 
    ensures Equal(Equal(Equal(eq)))(Map(Duplicate)(Duplicate(w)), Duplicate(Duplicate(w)))
}

abstract module {:options "-functionSyntax:4"} CoreaderRightComonad refines Comonad {
  import Coreader

  type X(!new)

  function eql(x: X, y: X): bool

  lemma LemmaEquiv()
    ensures EquivalenceRelation(eql)

  /* Functor structure */
  type W(!new)<T(!new)> = Coreader.Coreader<X,T>

  function Map<S(!new),T(!new)>(f: S -> T): W<S> -> W<T> {
    Coreader.MapRight(f)
  }

  ghost function Equal<T(!new)>(eq: (T, T) -> bool): (W<T>, W<T>) -> bool {
    Coreader.Equal(eql, eq)
  }  

  /* Properties of Equal */
  lemma LemmaEquivRelLift<T(!new)>(eq: (T, T) -> bool) {
    LemmaEquiv();
  }

  /* Properties of Map */
  lemma LemmaMapFunction<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, g: S -> T) {
    LemmaEquiv();
  }

  lemma LemmaMapFunctorial<S(!new),T(!new),U(!new)>(eq: (U, U) -> bool, f: S -> T, g: T -> U, w: W<S>) {
    LemmaEquiv();
  }

  lemma LemmaMapIdentity<T(!new)>(eq: (T, T) -> bool, id: T -> T) {
    LemmaEquiv();
  }

  /* Comonad structure */
  function Extract<T(!new)>(w: W<T>): T {
    Coreader.ExtractRight(w)
  } 

  function Duplicate<T(!new)>(w: W<T>): W<W<T>> {
    Coreader.DuplicateLeft(w)
  }

  /* Naturality of Extract and Duplicate */
  lemma LemmaExtractNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>) {
  }

  lemma LemmaDuplicateNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>) {
    LemmaEquiv();
  }

  /* Comonad laws */
  lemma LemmaCoUnitalityExtract<T(!new)>(eq: (T, T) -> bool, w: W<T>) {
    LemmaEquiv();
  }
 
  lemma LemmaCoAssociativityDuplicate<T(!new)>(eq: (T, T) -> bool, w: W<T>) {
    LemmaEquiv();
  }
}

abstract module {:options "-functionSyntax:4"} CoreaderLeftComonad refines Comonad {
  import Coreader

  type X(!new)

  function eqr(x: X, y: X): bool

  lemma LemmaEquiv()
    ensures EquivalenceRelation(eqr)

  /* Functor structure */
  type W(!new)<T(!new)> = Coreader.Coreader<T,X>

  function Map<S(!new),T(!new)>(f: S -> T): W<S> -> W<T> {
    Coreader.MapLeft(f)
  }

  ghost function Equal<T(!new)>(eq: (T, T) -> bool): (W<T>, W<T>) -> bool {
    Coreader.Equal(eq, eqr)
  }  

  /* Properties of Equal */
  lemma LemmaEquivRelLift<T(!new)>(eq: (T, T) -> bool) {
    LemmaEquiv();
  }

  /* Properties of Map */
  lemma LemmaMapFunction<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, g: S -> T) {
    LemmaEquiv();
  }

  lemma LemmaMapFunctorial<S(!new),T(!new),U(!new)>(eq: (U, U) -> bool, f: S -> T, g: T -> U, w: W<S>) {
    LemmaEquiv();
  }

  lemma LemmaMapIdentity<T(!new)>(eq: (T, T) -> bool, id: T -> T) {
    LemmaEquiv();
  }

  /* Comonad structure */
  function Extract<T(!new)>(w: W<T>): T {
    Coreader.ExtractLeft(w)
  } 

  function Duplicate<T(!new)>(w: W<T>): W<W<T>> {
    Coreader.DuplicateRight(w)
  }

  /* Naturality of Extract and Duplicate */
  lemma LemmaExtractNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>) {
  }

  lemma LemmaDuplicateNaturality<S(!new),T(!new)>(eq: (T, T) -> bool, f: S -> T, w: W<S>) {
    LemmaEquiv();
  }

  /* Comonad laws */
  lemma LemmaCoUnitalityExtract<T(!new)>(eq: (T, T) -> bool, w: W<T>) {
    LemmaEquiv();
  }
 
  lemma LemmaCoAssociativityDuplicate<T(!new)>(eq: (T, T) -> bool, w: W<T>) {
    LemmaEquiv();
  }

}