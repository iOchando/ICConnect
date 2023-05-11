import Text "mo:base/Text";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import List "mo:base/List";
import Types "types";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Array "mo:base/Array";

actor {
  var users_id : Nat = 0;
  var posts_id : Nat = 0;

  type Time = Int;

  type User = Types.User;

  type UserView = Types.UserView;

  type Post = Types.Post;

  type PostView = Types.PostView;

  var users = HashMap.HashMap<Text, UserView>(0, Text.equal, Text.hash);

  var posts = HashMap.HashMap<Text, PostView>(0, Text.equal, Text.hash);

  public shared (msg) func createUser(user : User) : async User {
    users_id += 1;

    let userView : UserView = {
      id : Text = Nat.toText(users_id);
      username : Text = user.username;
      name : ?Text = user.name;
      last_name : ?Text = user.last_name;
      email : ?Text = user.email;
      avatar : ?Text = user.avatar;
    };

    users.put(Nat.toText(users_id), userView);

    userView;
  };

  public query func getUsers() : async [UserView] {
    Iter.toArray(users.vals());
  };

  public query func getUserById(user_id : Text) : async ?UserView {
    users.get(user_id);
  };

  public shared func deleteUser(user_id : Text) : async ?UserView {
    users.remove(user_id);
  };

  public shared func updateUser(user_id : Text, user : User) : async ?UserView {
    let userOld : ?UserView = users.get(user_id);

    if (userOld == null) return null;

    let userView : UserView = {
      id : Text = user_id;
      username : Text = user.username;
      name : ?Text = user.name;
      last_name : ?Text = user.last_name;
      email : ?Text = user.email;
      avatar : ?Text = user.avatar;
    };

    users.replace(user_id, userView);
  };

  public shared (msg) func Post(user_id : Text, post : Post) : async ?PostView {
    let user = users.get(user_id);

    if (user == null) return null;

    posts_id += 1;

    let postView : PostView = {
      id : Text = Nat.toText(posts_id);
      user : Text = user_id;
      content : Text = post.content;
      likes : Int = 0;
      date_time : Time = Time.now();
    };

    posts.put(Nat.toText(posts_id), postView);

    posts.get(Nat.toText(posts_id));
  };

  public query func getPosts() : async [PostView] {
    Iter.toArray(posts.vals());
  };

  public query func getPostById(post_id : Text) : async ?PostView {
    posts.get(post_id);
  };

  public query func getPostByUserId(user_id : Text) : async [PostView] {
    let userMessages = Array.filter<PostView>(
      Iter.toArray(posts.vals()),
      func x = x.user == user_id,
    );
  };

  public shared func likePost(post_id : Text) : async ?PostView {
    var postOld : ?PostView = posts.get(post_id);

    if (postOld == null) { return null };

    var postNow : PostView = switch postOld {
      case (null) {
        {
          id : Text = "";
          user : Text = "";
          content : Text = "";
          likes : Int = 0;
          date_time : Time = Time.now();
        };
      };
      case (?postOld) postOld;
    };

    let postNew : PostView = {
      id : Text = postNow.id;
      user : Text = postNow.user;
      content : Text = postNow.content;
      likes : Int = postNow.likes + 1;
      date_time : Time = postNow.date_time;
    };

    posts.replace(post_id, postNew);
  };
};
