
## 7. Questions

**1. What is the difference between an index, a sourcetype, and a field in Splunk?**

An index is the physical repository where Splunk stores ingested event data (for example, `index=main`). A sourcetype classifies the format and structure of the data within an index — such as `web_traffic` versus `firewall_logs` — telling Splunk how to parse timestamps and extract fields correctly. A field is an individual key-value attribute pulled out of an event, such as `client_ip`, `status`, or `path`, and it is what can actually be searched, filtered, or tabled in a query.

**2. What does the pipe (|) operator do in SPL, and why is it central to how Splunk searches work?**

The pipe passes the output of one command as the input to the next, letting a search be built as a chained pipeline: search, then filter, then transform, then visualise — similar to piping in a Linux shell. This is why raw event searches in this lab could be progressively narrowed and reshaped by adding `table`, `stats`, `timechart`, `sort`, and `dedup` after the initial search, rather than having to write one giant query.

**3. What is the purpose of the "Interesting Fields" panel, and how did it help you during this investigation?**

The Interesting Fields panel surfaces fields Splunk automatically extracted from the raw events, along with how many distinct values each field has. This made it possible to quickly spot anomalies without writing a query first — for example, seeing that `client_ip` had only one distinct value across all the suspicious (non-browser) traffic immediately pointed to a single attacker IP responsible for the whole attack.

**4. Why is choosing the correct time range important in Splunk, and what could go wrong if it's set incorrectly?**

The time range determines which slice of the indexed data a search actually looks at, so an incorrect range can make real events silently disappear from the results. This happened directly during the investigation: a search for `EventCode=8` (process migration) returned 0 events because the time range was set to "All time (real-time)" instead of the historical "All time" option — real-time mode only watches events arriving from that moment forward, so it never looked at the 2021 data already sitting in the index. Switching to historical "All time" immediately returned the expected results.

**5. How would you make a search you wrote today reusable as an alert that fires automatically in the future?**

The search would first be saved as a Report, then configured as an Alert with a schedule (for example, running every 15 minutes) and a trigger condition (for example, number of results greater than 0). An action would then be attached to the alert, such as sending an email notification or logging the match to a triggered-alerts list, so that if the same pattern of activity appeared again it would be flagged automatically instead of relying on a manual search.

**6. Why did the analyst pivot from Sysmon logs to IIS logs (and back) during the investigation? What does each log source tell you that the other doesn't?**

Sysmon logs record process-level activity on the host itself — what executable ran, what file it created, what process it injected into — but they do not show the network request that triggered that activity. IIS logs record the actual HTTP requests hitting the web server (method, URL, status code, source IP) but not what happened on the host afterward. Pivoting between the two was necessary to connect the incoming POST request to `/owa/auth/i3gfPctK1c2x.aspx` (visible only in IIS logs) with the resulting process activity of `attrib.exe` and `cmd.exe` on the server (visible only in Sysmon logs) — neither log source alone told the complete story.

**7. Why do attackers use process migration/injection (e.g. into a legitimate process) instead of just running their tools directly?**

Migrating into a legitimate, trusted process — such as `unsecapp.exe` or `lsass.exe` — helps an attacker blend in with normal system activity and evade detection tools that flag unusual standalone processes. It can also help the attacker survive if the original entry-point process (in this case, PowerShell) is closed or killed, since their access now lives inside a different, ongoing process. In the specific case of migrating into `lsass.exe`, there is an added benefit: that process holds credential material in memory, so operating inside it also enables direct credential theft.