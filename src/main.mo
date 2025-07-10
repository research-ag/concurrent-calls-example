import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import R "mo:base/Result";

import Concurrent "concurrent_calls";

actor HelloWorld {

  private let canisterIds = [
    "rwlgt-iiaaa-aaaaa-aaaaa-cai",
    "rrkah-fqaaa-aaaaa-aaaaq-cai",
    "ryjl3-tyaaa-aaaaa-aaaba-cai",
    "r7inp-6aaaa-aaaaa-aaabq-cai",
    "rkp4c-7iaaa-aaaaa-aaaca-cai",
    "rno2w-sqaaa-aaaaa-aaacq-cai",
    "renrk-eyaaa-aaaaa-aaada-cai",
    "rdmx6-jaaaa-aaaaa-aaadq-cai",
    "qoctq-giaaa-aaaaa-aaaea-cai",
    "qjdve-lqaaa-aaaaa-aaaeq-cai",
  ] |> Array.map<Text, Principal>(_, func p = Principal.fromText(p));

  public func makeCalls(n : Nat) : async [R.Result<Nat64, Text>] {
    let res = Array.init<R.Result<Nat64, Text>>(n, #err("N/A"));
    let calls = Buffer.Buffer<Concurrent.Item>(n);

    for (i in Iter.range(0, n - 1)) {
      calls.add({
        call_arg = {
          canister_id = canisterIds[i % canisterIds.size()];
          num_requested_changes = ?(20 : Nat64);
        };
        register_call = func() = res[i] := #err("Call registered");
        register_fail_cb = func() = res[i] := #err("Failed to schedule the call");
        process_response = func(info) = res[i] := #ok(info.total_num_changes);
        process_error = func(e) = res[i] := #err(Error.message(e));
      });
    };
    await* Concurrent.make_calls(Buffer.toArray(calls), func(i) = ());
    Array.freeze(res);
  };

};
