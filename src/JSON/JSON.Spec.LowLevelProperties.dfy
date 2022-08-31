include "JSON.LowLevel.Spec.dfy"

module {:options "/functionSyntax:4"} JSON.LowLevel.SpecProperties {
  import opened BoundedInts

  import Vs = Views.Core
  import opened Grammar
  import Spec

  lemma Bracketed_Morphism<D, S>(bracketed: Bracketed<Vs.View, D, S, Vs.View>) // DISCUSS
    ensures forall pd0: Suffixed<D, S> --> bytes, pd1: Suffixed<D, S> --> bytes
      | && (forall d | d < bracketed :: pd0.requires(d))
        && (forall d | d < bracketed :: pd1.requires(d))
        && (forall d | d < bracketed :: pd0(d) == pd1(d))
      :: Spec.Bracketed(bracketed, pd0) == Spec.Bracketed(bracketed, pd1)
  {
    forall pd0: Suffixed<D, S> --> bytes, pd1: Suffixed<D, S> --> bytes
      | && (forall d | d < bracketed :: pd0.requires(d))
        && (forall d | d < bracketed :: pd1.requires(d))
        && (forall d | d < bracketed :: pd0(d) == pd1(d))
    {
      calc {
        Spec.Bracketed(bracketed, pd0);
        { ConcatBytes_Morphism(bracketed.data, pd0, pd1); }
        Spec.Bracketed(bracketed, pd1);
      }
    }
  }

  lemma {:induction ts} ConcatBytes_Morphism<T>(ts: seq<T>, pt0: T --> bytes, pt1: T --> bytes)
    requires forall d | d in ts :: pt0.requires(d)
    requires forall d | d in ts :: pt1.requires(d)
    requires forall d | d in ts :: pt0(d) == pt1(d)
    ensures Spec.ConcatBytes(ts, pt0) == Spec.ConcatBytes(ts, pt1)
  {}

  lemma {:induction ts0} ConcatBytes_Linear<T>(ts0: seq<T>, ts1: seq<T>, pt: T --> bytes)
    requires forall d | d in ts0 :: pt.requires(d)
    requires forall d | d in ts1 :: pt.requires(d)
    ensures Spec.ConcatBytes(ts0 + ts1, pt) == Spec.ConcatBytes(ts0, pt) + Spec.ConcatBytes(ts1, pt)
  {
    if |ts0| == 0 {
      assert [] + ts1 == ts1;
    } else {
      assert ts0 + ts1 == [ts0[0]] + (ts0[1..] + ts1);
    }
  }
}