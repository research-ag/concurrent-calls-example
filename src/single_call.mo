
module {
  let ic = actor "aaaaa-aa" : Management;
  public type Arg = CanisterInfoRequest;
  public type Response = CanisterInfoResponse;
  public let f = ic.canister_info;

  type CanisterChange = {
    timestamp_nanos : Nat64;
    canister_version : Nat64;
    origin : CanisterChangeOrigin;
    details : CanisterChangeDetails;
  };

  type CanisterChangeDetails = {
    #creation : CreationRecord;
    #code_deployment : CodeDeploymentRecord;
    #controllers_change : CreationRecord;
    #code_uninstall;
    #load_snapshot : SnapshotRecord;
  };

  type CanisterChangeOrigin = {
    #from_user : {
      user_id : Principal;
    };
    #from_canister : {
      canister_id : Principal;
      canister_version : ?Nat64;
    };
  };

  type CodeDeploymentRecord = {
    mode : CanisterInstallMode;
    module_hash : Blob;
  };

  type CanisterInstallMode = {
    #reinstall;
    #upgrade;
    #install;
  };

  type CreationRecord = {
    controllers : [Principal];
  };

  type SnapshotRecord = {
    canister_version : Nat64;
    snapshot_id : Blob;
    taken_at_timestamp : Nat64;
  };

  type CanisterInfoRequest = {
    canister_id : Principal;
    num_requested_changes : ?Nat64;
  };

  type CanisterInfoResponse = {
    total_num_changes : Nat64;
    recent_changes : [CanisterChange];
    module_hash : ?[Nat8];
    controllers : [Principal];
  };

  type Management = actor {
    canister_info : query CanisterInfoRequest -> async CanisterInfoResponse;
  };
};
