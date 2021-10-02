module Credentials = {
  type t = {
    password: string,
    passwordAgain: string,
  }
  let decode = val => {
    open Funicular.Decode
    let o = object_(val)
    rmap((password, passwordAgain) => {password: password, passwordAgain: passwordAgain})
    ->v(o->field("password", string))
    ->v(o->field("passwordAgain", string))
  }
}
module User = {
  type t = {
    id: string,
    name: string,
    email: string,
    age: option<int>,
  }

  let encode = ({id, name, email, age}) => {
    open Funicular.Encode
    object_([
      ("id", string(id)),
      ("name", string(name)),
      ("email", string(email)),
      ("age", optional(age, integer)),
    ])
  }
  let decode = val => {
    open Funicular.Decode
    let o = val->object_

    let id = o->field("id", string)
    let name = o->field("name", string)
    let email = o->field("email", string)
    let age = o->field("id", optional(integer))
    rmap((id, name, email, age) => {id: id, name: name, email: email, age: age})
    ->v(id)
    ->v(name)
    ->v(email)
    ->v(age)
  }

  /**
   * Decoding the User.t without the assistance of funicular
   */
  let decodeManual = value => {
    switch Js.Json.decodeObject(value) {
    | Some(o) => {
        let id = Js.Dict.get(o, "id")->Belt.Option.map(Js.Json.decodeString)
        let name = Js.Dict.get(o, "name")->Belt.Option.map(Js.Json.decodeString)
        let email = Js.Dict.get(o, "email")->Belt.Option.map(Js.Json.decodeString)
        let age =
          Js.Dict.get(o, "age")->Belt.Option.map(x =>
            Belt.Option.map(Js.Json.decodeNumber(x), y => Belt.Int.fromFloat(y))
          )
        switch (id, name, email, age) {
        | (Some(Some(id)), Some(Some(name)), Some(Some(email)), Some(age)) =>
          Ok({id: id, name: name, email: email, age: age})
        | _ => Error(`one or more properties missing`)
        }
      }
    | None => Error(`Not an object`)
    }
  }
}

module RegisterUserRequest = {
  type t = {
    name: string,
    email: string,
    age: option<int>,
    credentials: Credentials.t,
  }

  let decode = val => {
    open Funicular.Decode
    let o = val->object_
    rmap((name, email, age, credentials) => {
      name: name,
      email: email,
      age: age,
      credentials: credentials,
    })
    ->v(o->field("name", string))
    ->v(o->field("email", string))
    ->v(o->field("age", optional(integer)))
    ->v(o->field("credentials", Credentials.decode))
  }
}

module RegisterUserResponse = {
  type t = {user: User.t}

  let encode = val => {
    open Funicular.Encode
    object_([("user", User.encode(val.user))])
  }
}

module Error = {
  type t = {code: string, message: string}
  let encode = val => {
    open Funicular.Encode
    object_([("code", string(val.code)), ("message", string(val.message))])
  }
}
