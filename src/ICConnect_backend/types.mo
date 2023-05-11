import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

module {
  public type User = {
    username : Text;
    name : ?Text;
    last_name : ?Text;
    email : ?Text;
    avatar : ?Text;
  };

  public type UserView = {
    id : Text;
    username : Text;
    name : ?Text;
    last_name : ?Text;
    email : ?Text;
    avatar : ?Text;
  };

  type Time = Int;

  public type Post = {
    content : Text;
  };

  public type PostView = {
    id : Text;
    user : Text;
    content : Text;
    likes : Int;
    date_time : Time;
  };
};
