(**************************************************************************)
(*                                                                        *)
(*                            LFSCtoSmtCoq                                *)
(*                                                                        *)
(*                         Copyright (C) 2016                             *)
(*          by the Board of Trustees of the University of Iowa            *)
(*                                                                        *)
(*                    Alain Mebsout and Burak Ekici                       *)
(*                       The University of Iowa                           *)
(*                                                                        *)
(*                                                                        *)
(*  This file is distributed under the terms of the Apache Software       *)
(*  License version 2.0                                                   *)
(*                                                                        *)
(**************************************************************************)

(**
   Signature to implement to build a converter of LFSC proofs.
   See {!Converter.Make}, {!Tosmtcoq} and {!VeritPrinter}.
*)

open Ast
open Format


(** The type of destination rules that are currently supported byt the
    converter *)
type rule =
  | Reso
  | Weak
  | Or
  | Orp
  | Imp
  | Impp
  | Nand
  | Andn
  | Nimp1
  | Nimp2
  | Impn1
  | Impn2
  | Nor
  | Orn
  | And
  | Andp
  | Equ1
  | Equ2
  | Nequ1
  | Nequ2
  | Equp1
  | Equp2
  | Equn1
  | Equn2
  | Xor1
  | Xor2
  | Xorp1
  | Xorp2
  | Xorn1
  | Xorn2
  | Nxor1
  | Nxor2
  | Eqtr
  | Eqcp
  | Eqco
  | Eqre
  | Lage
  | Flat
  | Hole
  | True
  | Fals
  | Bbva
  | Bbconst
  | Bbeq
  | Bbop
  | Bbadd
  | Bbmul
  | Bbult
  | Bbslt
  | Bbnot
  | Bbneg
  | Row1
  | Row2 

(** Signature for translators *)
module type S = sig

  (** The type of literal depends on the chosen tranlation, it is abstract *)
  type lit

  (** Clauses are lists of the aforementioned literals *)
  type clause = lit list

  (** Transform a term in LFSC to the chosen clause representation. (This
      eliminates top-level dijunctions and implications.) *)
  val to_clause : term -> clause

  (** Print a clause (for debugging purposes) *)
  val print_clause : formatter -> clause -> unit

  (** Manually resgister a clause with an integer identifier *)
  val register_clause_id : clause -> int -> unit

  (** Create a new clause as the result of a rule application with a list of
      intgeger arguments. These can be either previously defined clause
      identifiers or an arbitrary positive integer depending on the rule.  It
      returns the identifier of the newly created resulting clause. The
      optional arguemnt [reuse] ([true] by default) says if we should reuse
      clauses that were previously deduced, in this case the rule application
      will not be created and it returns the identifier of this pre-existing
      clause. *)
  val mk_clause : ?reuse:bool -> rule -> clause -> int list -> int

  (** Same as {!mk_clause} but with an hybrid representation for clauses. This
      is just used to avoid creating unecessary terms for these clauses when
      they are built by hand. *)
  val mk_clause_cl : ?reuse:bool -> rule -> term list -> int list -> int

  (** Create an input unit clause. It is given an identifier that is not
      returned. *)
  val mk_input : string -> term -> unit

  val mk_admit_preproc : string -> term -> unit
    
  (** [register_prop_abstr v p] register the term [v] as being a propositional
      abstraction of the term [p]. *)
  val register_prop_abstr : term -> term -> unit

  (** Returns the identifier of a previously deduced clause. *)
  val get_clause_id : clause -> int

  (** Returns the identifier of a unit input clause given its name, as
      intoduced by the proprocessor of CVC4 in the LFSC proof. *)
  val get_input_id : string -> int

  val register_decl : string -> term -> unit

  val register_decl_id : string -> int -> unit

  (** Clear and reset global tables and values. *)
  val clear : unit -> unit
  
end
