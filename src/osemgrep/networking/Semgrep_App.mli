type scan_id = string
type app_block_override = string (* reason *) option

(* retrieves the deployment config from the provided token. *)
val get_deployment_from_token :
  token:Auth.token -> Semgrep_output_v1_t.deployment_config option

(* retrieves the scan config from the provided token. *)
val get_scan_config_from_token :
  token:Auth.token -> Semgrep_output_v1_t.scan_config option

(* internally rely on api_token in ~/.settings and SEMGREP_REPO_NAME *)
val url_for_policy : token:Auth.token -> Uri.t

(* construct the Uri where to retrieve the scan configuration, depending on
   the parameters and the repository name *)
val scan_config_uri :
  ?sca:bool -> ?dry_run:bool -> ?full_scan:bool -> string -> Uri.t

val start_scan :
  dry_run:bool ->
  token:Auth.token ->
  Project_metadata.t ->
  Semgrep_output_v1_t.scan_metadata ->
  (scan_id, string) result
(** [start_scan ~dry_run ~token url prj] informs the Semgrep App that a scan
    is about to be started, and returns the scan id from the server. If
    [dry_run] is [true], the empty string will be returned ([Ok ""]). *)

(* TODO: diff with get_scan_config_from_token? *)
val fetch_scan_config :
  dry_run:bool ->
  token:Auth.token ->
  sca:bool ->
  full_scan:bool ->
  repository:string ->
  (Semgrep_output_v1_t.scan_config, string) result
(** [fetch_scan_config ~token ~sca ~dry_run ~full_scan repo] returns the rules
    (as a RAW string containing JSON data) for the provided configuration. *)

(* upload both the scan_results and complete *)
val upload_findings :
  dry_run:bool ->
  token:Auth.token ->
  scan_id:scan_id ->
  results:Semgrep_output_v1_t.ci_scan_results ->
  complete:Semgrep_output_v1_t.ci_scan_complete ->
  (app_block_override, string) result
(** [upload_findings ~dry_run ~token ~scan_id ~results ~complete]
    reports the findings to Semgrep App. *)

(* report a failure for [scan_id] to Semgrep App *)
val report_failure :
  dry_run:bool -> token:Auth.token -> scan_id:scan_id -> Exit_code.t -> unit

(* lwt-friendly versions for the language-server *)

val get_deployment_from_token_async :
  token:Auth.token -> Semgrep_output_v1_t.deployment_config option Lwt.t

val get_scan_config_from_token_async :
  token:Auth.token -> Semgrep_output_v1_t.scan_config option Lwt.t

val fetch_scan_config_async :
  dry_run:bool ->
  token:Auth.token ->
  sca:bool ->
  full_scan:bool ->
  repository:string ->
  (Semgrep_output_v1_t.scan_config, string) result Lwt.t
(** [fetch_scan_config_async ~token ~sca ~dry_run ~full_scan repo] returns a
     promise of the rules for the provided configuration. *)
