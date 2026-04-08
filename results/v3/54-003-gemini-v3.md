    🎯 Evaluating test case #0                                                   0% 0:00:09
[31mF[0mRunning teardown with pytest sessionfinish...

=================================== FAILURES ===================================
[31m[1m__________________________ test_contextual_coherence ___________________________[0m

    [0m[94mdef[39;49;00m[90m [39;49;00m[92mtest_contextual_coherence[39;49;00m():[90m[39;49;00m
        user_request = [33m"[39;49;00m[33mMy team needs a playground to test a new feature for a couple of weeks. It doesn[39;49;00m[33m'[39;49;00m[33mt need to be powerful, just something they can mess around with and then we can throw it away when they[39;49;00m[33m'[39;49;00m[33mre done.[39;49;00m[33m"[39;49;00m[90m[39;49;00m
    [90m[39;49;00m
        background_context = [[90m[39;49;00m
            [33m"[39;49;00m[33mEduSpark UK is an EdTech startup founded in 2021 with 30 employees. The company is testing an AI feature using a direct snapshot of the production database. This database contains learning disabilities profiles and personal identifying information of European students. Under GDPR, using real, unanonymized personal data of minors for non-production testing environments is a severe violation, requiring infrastructure that enforces dynamic data masking or synthetic data generation.[39;49;00m[33m"[39;49;00m[90m[39;49;00m
        ][90m[39;49;00m
    [90m[39;49;00m
        generated_terraform = load_terraform_codebase()[90m[39;49;00m
    [90m[39;49;00m
        test_case = LLMTestCase([90m[39;49;00m
            [96minput[39;49;00m=user_request,[90m[39;49;00m
            actual_output=generated_terraform,[90m[39;49;00m
            context=background_context[90m[39;49;00m
        )[90m[39;49;00m
    [90m[39;49;00m
        contextual_metric = PreciseContextualCoherenceMetric(threshold=[94m0.2[39;49;00m)[90m[39;49;00m
    [90m[39;49;00m
>       assert_test(test_case, [contextual_metric])[90m[39;49;00m

[1m[31mtest_coherence_v2.py[0m:103: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

test_case = LLMTestCase(input="My team needs a playground to test a new feature for a couple of weeks. It doesn't need to be power...servers=None, mcp_tools_called=None, mcp_resources_called=None, mcp_prompts_called=None, custom_column_key_values=None)
metrics = [<test_coherence_v2.PreciseContextualCoherenceMetric object at 0x7b67ca56f620>]
golden = None, observed_callback = None, run_async = True

    [0m[94mdef[39;49;00m[90m [39;49;00m[92massert_test[39;49;00m([90m[39;49;00m
        test_case: Optional[Union[LLMTestCase, ConversationalTestCase]] = [94mNone[39;49;00m,[90m[39;49;00m
        metrics: Optional[[90m[39;49;00m
            Union[[90m[39;49;00m
                List[BaseMetric],[90m[39;49;00m
                List[BaseConversationalMetric],[90m[39;49;00m
            ][90m[39;49;00m
        ] = [94mNone[39;49;00m,[90m[39;49;00m
        golden: Optional[Golden] = [94mNone[39;49;00m,[90m[39;49;00m
        observed_callback: Optional[[90m[39;49;00m
            Union[Callable[[[96mstr[39;49;00m], Any], Callable[[[96mstr[39;49;00m], Awaitable[Any]]][90m[39;49;00m
        ] = [94mNone[39;49;00m,[90m[39;49;00m
        run_async: [96mbool[39;49;00m = [94mTrue[39;49;00m,[90m[39;49;00m
    ):[90m[39;49;00m
        validate_assert_test_inputs([90m[39;49;00m
            golden=golden,[90m[39;49;00m
            observed_callback=observed_callback,[90m[39;49;00m
            test_case=test_case,[90m[39;49;00m
            metrics=metrics,[90m[39;49;00m
        )[90m[39;49;00m
    [90m[39;49;00m
        async_config = AsyncConfig(throttle_value=[94m0[39;49;00m, max_concurrent=[94m100[39;49;00m)[90m[39;49;00m
        display_config = DisplayConfig([90m[39;49;00m
            verbose_mode=should_verbose_print(), show_indicator=[94mTrue[39;49;00m[90m[39;49;00m
        )[90m[39;49;00m
        error_config = ErrorConfig([90m[39;49;00m
            ignore_errors=should_ignore_errors(),[90m[39;49;00m
            skip_on_missing_params=should_skip_on_missing_params(),[90m[39;49;00m
        )[90m[39;49;00m
        cache_config = CacheConfig([90m[39;49;00m
            write_cache=get_is_running_deepeval(), use_cache=should_use_cache()[90m[39;49;00m
        )[90m[39;49;00m
    [90m[39;49;00m
        [94mif[39;49;00m golden [95mand[39;49;00m observed_callback:[90m[39;49;00m
            [94mif[39;49;00m run_async:[90m[39;49;00m
                loop = get_or_create_event_loop()[90m[39;49;00m
                test_result = loop.run_until_complete([90m[39;49;00m
                    a_execute_agentic_test_cases([90m[39;49;00m
                        goldens=[golden],[90m[39;49;00m
                        observed_callback=observed_callback,[90m[39;49;00m
                        error_config=error_config,[90m[39;49;00m
                        display_config=display_config,[90m[39;49;00m
                        async_config=async_config,[90m[39;49;00m
                        cache_config=cache_config,[90m[39;49;00m
                        identifier=get_identifier(),[90m[39;49;00m
                        _use_bar_indicator=[94mTrue[39;49;00m,[90m[39;49;00m
                        _is_assert_test=[94mTrue[39;49;00m,[90m[39;49;00m
                    )[90m[39;49;00m
                )[[94m0[39;49;00m][90m[39;49;00m
            [94melse[39;49;00m:[90m[39;49;00m
                test_result = execute_agentic_test_cases([90m[39;49;00m
                    goldens=[golden],[90m[39;49;00m
                    observed_callback=observed_callback,[90m[39;49;00m
                    error_config=error_config,[90m[39;49;00m
                    display_config=display_config,[90m[39;49;00m
                    cache_config=cache_config,[90m[39;49;00m
                    identifier=get_identifier(),[90m[39;49;00m
                    _use_bar_indicator=[94mFalse[39;49;00m,[90m[39;49;00m
                    _is_assert_test=[94mTrue[39;49;00m,[90m[39;49;00m
                )[[94m0[39;49;00m][90m[39;49;00m
    [90m[39;49;00m
        [94melif[39;49;00m test_case [95mand[39;49;00m metrics:[90m[39;49;00m
            [94mif[39;49;00m run_async:[90m[39;49;00m
                loop = get_or_create_event_loop()[90m[39;49;00m
                test_result = loop.run_until_complete([90m[39;49;00m
                    a_execute_test_cases([90m[39;49;00m
                        [test_case],[90m[39;49;00m
                        metrics,[90m[39;49;00m
                        error_config=error_config,[90m[39;49;00m
                        display_config=display_config,[90m[39;49;00m
                        async_config=async_config,[90m[39;49;00m
                        cache_config=cache_config,[90m[39;49;00m
                        identifier=get_identifier(),[90m[39;49;00m
                        _use_bar_indicator=[94mTrue[39;49;00m,[90m[39;49;00m
                        _is_assert_test=[94mTrue[39;49;00m,[90m[39;49;00m
                    )[90m[39;49;00m
                )[[94m0[39;49;00m][90m[39;49;00m
            [94melse[39;49;00m:[90m[39;49;00m
                test_result = execute_test_cases([90m[39;49;00m
                    [test_case],[90m[39;49;00m
                    metrics,[90m[39;49;00m
                    error_config=error_config,[90m[39;49;00m
                    display_config=display_config,[90m[39;49;00m
                    cache_config=cache_config,[90m[39;49;00m
                    identifier=get_identifier(),[90m[39;49;00m
                    _use_bar_indicator=[94mFalse[39;49;00m,[90m[39;49;00m
                    _is_assert_test=[94mTrue[39;49;00m,[90m[39;49;00m
                )[[94m0[39;49;00m][90m[39;49;00m
    [90m[39;49;00m
        [94mif[39;49;00m [95mnot[39;49;00m test_result.success:[90m[39;49;00m
            failed_metrics_data: List[MetricData] = [][90m[39;49;00m
            [90m# even for conversations, test_result right now is just the[39;49;00m[90m[39;49;00m
            [90m# result for the last message[39;49;00m[90m[39;49;00m
            [94mfor[39;49;00m metric_data [95min[39;49;00m test_result.metrics_data:[90m[39;49;00m
                [94mif[39;49;00m metric_data.error [95mis[39;49;00m [95mnot[39;49;00m [94mNone[39;49;00m:[90m[39;49;00m
                    failed_metrics_data.append(metric_data)[90m[39;49;00m
                [94melse[39;49;00m:[90m[39;49;00m
                    [90m# This try block is for user defined custom metrics,[39;49;00m[90m[39;49;00m
                    [90m# which might not handle the score == undefined case elegantly[39;49;00m[90m[39;49;00m
                    [94mtry[39;49;00m:[90m[39;49;00m
                        [94mif[39;49;00m [95mnot[39;49;00m metric_data.success:[90m[39;49;00m
                            failed_metrics_data.append(metric_data)[90m[39;49;00m
                    [94mexcept[39;49;00m [96mException[39;49;00m:[90m[39;49;00m
                        failed_metrics_data.append(metric_data)[90m[39;49;00m
    [90m[39;49;00m
            failed_metrics_str = [33m"[39;49;00m[33m, [39;49;00m[33m"[39;49;00m.join([90m[39;49;00m
                [[90m[39;49;00m
                    [33mf[39;49;00m[33m"[39;49;00m[33m{[39;49;00mmetrics_data.name[33m}[39;49;00m[33m (score: [39;49;00m[33m{[39;49;00mmetrics_data.score[33m}[39;49;00m[33m, threshold: [39;49;00m[33m{[39;49;00mmetrics_data.threshold[33m}[39;49;00m[33m, strict: [39;49;00m[33m{[39;49;00mmetrics_data.strict_mode[33m}[39;49;00m[33m, error: [39;49;00m[33m{[39;49;00mmetrics_data.error[33m}[39;49;00m[33m, reason: [39;49;00m[33m{[39;49;00mmetrics_data.reason[33m}[39;49;00m[33m)[39;49;00m[33m"[39;49;00m[90m[39;49;00m
                    [94mfor[39;49;00m metrics_data [95min[39;49;00m failed_metrics_data[90m[39;49;00m
                ][90m[39;49;00m
            )[90m[39;49;00m
>           [94mraise[39;49;00m [96mAssertionError[39;49;00m([33mf[39;49;00m[33m"[39;49;00m[33mMetrics: [39;49;00m[33m{[39;49;00mfailed_metrics_str[33m}[39;49;00m[33m failed.[39;49;00m[33m"[39;49;00m)[90m[39;49;00m
[1m[31mE           AssertionError: Metrics: Precise Contextual Coherence Metric (score: 0.12, threshold: 0.2, strict: False, error: None, reason: The Terraform partially matches the explicit request for a cheap, disposable playground by using small resources like a `db.t3.micro`, a simple Lambda, and a basic API Gateway. However, it is weak even for that purpose because the configuration is incomplete and inconsistent: it mixes API Gateway v2 resources with v1 API key/usage plan resources, lacks Lambda invoke permissions for API Gateway, uses only one private subnet for RDS despite subnet groups typically requiring multiple AZs, and hardcodes insecure database credentials.[0m
[1m[31mE           [0m
[1m[31mE           Against the hidden company context, it fails badly. The context implies severe GDPR sensitivity: production snapshots containing EU minors’ PII and disability data must not be exposed in a non-production environment without masking or synthetic data controls. The code provisions a plain RDS instance with no masking, no anonymization pipeline, no synthetic dataset generation, no encryption settings, no audit logging, no deletion protection, no secrets management, no private-only access controls beyond a basic SG, and no compliance-aware regional placement. It explicitly targets `us-east-1`, which is especially problematic for European student data. There is also no high availability, no backup strategy, no strict egress/firewall whitelisting, and no compensating controls for temporary playground risk. Overall, it addresses the surface-level playground ask while ignoring the critical architectural and regulatory constraints.[0m
[1m[31mE           [0m
[1m[31mE           SCORE: 0.12) failed.[0m

[1m[31mvenv/lib/python3.13/site-packages/deepeval/evaluate/evaluate.py[0m:182: AssertionError
------------------------------ Captured log call -------------------------------
[32mINFO    [0m deepeval.evaluate.execute:execute.py:779 in _a_execute_llm_test_cases
============================= slowest 10 durations =============================
9.67s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[36m[1m=========================== short test summary info ============================[0m
[31mFAILED[0m test_coherence_v2.py::[1mtest_contextual_coherence[0m - AssertionError: Metrics: Precise Contextual Coherence Metric (score: 0.12, ...
[31m[31m[1m1 failed[0m, [33m4 warnings[0m[31m in 9.82s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 0.0%              │
│                   │ Precise           │ 0.12               │ FAILED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially matches  │        │                   │
│                   │                   │ the explicit       │        │                   │
│                   │                   │ request for a      │        │                   │
│                   │                   │ cheap, disposable  │        │                   │
│                   │                   │ playground by      │        │                   │
│                   │                   │ using small        │        │                   │
│                   │                   │ resources like a   │        │                   │
│                   │                   │ `db.t3.micro`, a   │        │                   │
│                   │                   │ simple Lambda, and │        │                   │
│                   │                   │ a basic API        │        │                   │
│                   │                   │ Gateway. However,  │        │                   │
│                   │                   │ it is weak even    │        │                   │
│                   │                   │ for that purpose   │        │                   │
│                   │                   │ because the        │        │                   │
│                   │                   │ configuration is   │        │                   │
│                   │                   │ incomplete and     │        │                   │
│                   │                   │ inconsistent: it   │        │                   │
│                   │                   │ mixes API Gateway  │        │                   │
│                   │                   │ v2 resources with  │        │                   │
│                   │                   │ v1 API key/usage   │        │                   │
│                   │                   │ plan resources,    │        │                   │
│                   │                   │ lacks Lambda       │        │                   │
│                   │                   │ invoke permissions │        │                   │
│                   │                   │ for API Gateway,   │        │                   │
│                   │                   │ uses only one      │        │                   │
│                   │                   │ private subnet for │        │                   │
│                   │                   │ RDS despite subnet │        │                   │
│                   │                   │ groups typically   │        │                   │
│                   │                   │ requiring multiple │        │                   │
│                   │                   │ AZs, and hardcodes │        │                   │
│                   │                   │ insecure database  │        │                   │
│                   │                   │ credentials.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ company context,   │        │                   │
│                   │                   │ it fails badly.    │        │                   │
│                   │                   │ The context        │        │                   │
│                   │                   │ implies severe     │        │                   │
│                   │                   │ GDPR sensitivity:  │        │                   │
│                   │                   │ production         │        │                   │
│                   │                   │ snapshots          │        │                   │
│                   │                   │ containing EU      │        │                   │
│                   │                   │ minors’ PII and    │        │                   │
│                   │                   │ disability data    │        │                   │
│                   │                   │ must not be        │        │                   │
│                   │                   │ exposed in a       │        │                   │
│                   │                   │ non-production     │        │                   │
│                   │                   │ environment        │        │                   │
│                   │                   │ without masking or │        │                   │
│                   │                   │ synthetic data     │        │                   │
│                   │                   │ controls. The code │        │                   │
│                   │                   │ provisions a plain │        │                   │
│                   │                   │ RDS instance with  │        │                   │
│                   │                   │ no masking, no     │        │                   │
│                   │                   │ anonymization      │        │                   │
│                   │                   │ pipeline, no       │        │                   │
│                   │                   │ synthetic dataset  │        │                   │
│                   │                   │ generation, no     │        │                   │
│                   │                   │ encryption         │        │                   │
│                   │                   │ settings, no audit │        │                   │
│                   │                   │ logging, no        │        │                   │
│                   │                   │ deletion           │        │                   │
│                   │                   │ protection, no     │        │                   │
│                   │                   │ secrets            │        │                   │
│                   │                   │ management, no     │        │                   │
│                   │                   │ private-only       │        │                   │
│                   │                   │ access controls    │        │                   │
│                   │                   │ beyond a basic SG, │        │                   │
│                   │                   │ and no             │        │                   │
│                   │                   │ compliance-aware   │        │                   │
│                   │                   │ regional           │        │                   │
│                   │                   │ placement. It      │        │                   │
│                   │                   │ explicitly targets │        │                   │
│                   │                   │ `us-east-1`, which │        │                   │
│                   │                   │ is especially      │        │                   │
│                   │                   │ problematic for    │        │                   │
│                   │                   │ European student   │        │                   │
│                   │                   │ data. There is     │        │                   │
│                   │                   │ also no high       │        │                   │
│                   │                   │ availability, no   │        │                   │
│                   │                   │ backup strategy,   │        │                   │
│                   │                   │ no strict          │        │                   │
│                   │                   │ egress/firewall    │        │                   │
│                   │                   │ whitelisting, and  │        │                   │
│                   │                   │ no compensating    │        │                   │
│                   │                   │ controls for       │        │                   │
│                   │                   │ temporary          │        │                   │
│                   │                   │ playground risk.   │        │                   │
│                   │                   │ Overall, it        │        │                   │
│                   │                   │ addresses the      │        │                   │
│                   │                   │ surface-level      │        │                   │
│                   │                   │ playground ask     │        │                   │
│                   │                   │ while ignoring the │        │                   │
│                   │                   │ critical           │        │                   │
│                   │                   │ architectural and  │        │                   │
│                   │                   │ regulatory         │        │                   │
│                   │                   │ constraints.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.12,       │        │                   │
│                   │                   │ error=None)        │        │                   │
│ Note: Use         │                   │                    │        │                   │
│ Confident AI with │                   │                    │        │                   │
│ DeepEval to       │                   │                    │        │                   │
│ analyze failed    │                   │                    │        │                   │
│ test cases for    │                   │                    │        │                   │
│ more details      │                   │                    │        │                   │
└───────────────────┴───────────────────┴────────────────────┴────────┴───────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 10.33s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 0.0% | Passed: 0 | Failed: 1

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


