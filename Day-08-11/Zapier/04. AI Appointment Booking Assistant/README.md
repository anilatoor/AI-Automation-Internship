# Task 4 — AI Appointment Booking Assistant

## 📋 Task Description

Clinic chatbot that books appointments by extracting doctor/date/time from natural language, checking real availability against existing bookings, and preventing double-booking.

- **Chatbot collects:** Patient Name, Phone, Doctor/Specialist, Preferred Date, Preferred Time, Reason for Appointment
- **Doctor roster:** Dr. Ahmed (General Physician), Dr. Sara (Dermatologist), Dr. Ali (Cardiologist)
- **Table:** "Appointments" — Appointment ID, Patient, Phone, Doctor, Date, Time, Reason, Status
- **Booking logic:** extract doctor from message → convert relative dates ("tomorrow") to actual dates → extract time → search Appointments for a doctor+date+time match → if free, collect remaining details and create the record; if taken, offer alternative times instead of booking
- **Double-booking prevention:** Filter after the availability search only proceeds to Create Record on zero matches; re-check before the final create

## ⚙️ How It Works

1. **Chatbot** ("Clinic Booking Assistant", built on Zapier Chatbots) greets with: *"Hello! 👋 I'm the clinic's booking assistant. Tell me which doctor you'd like to see and your preferred date and time, and I'll check availability for you."* It's grounded on two Knowledge sources: the **Appointments** table itself (synced daily, so it's aware of existing bookings) and `Clinic Doctor Roster` (a text file listing the 3 doctors and specialties).
2. **Logic — "When a user uses certain keywords"** — once the bot has gathered enough info (doctor, date, time, reason, name, phone), it displays a **"Confirm Booking"** button, which runs the underlying **Zap**.
3. **Zap (AI by Zapier → Zapier Tables → Filter → Zapier Tables):**
   - **Chatbot Button Click** — trigger, fires from the "Confirm Booking" button.
   - **Analyse and Return Data** (AI by Zapier) — extracts the doctor name, converts relative dates ("tomorrow") into an actual calendar date, and extracts the requested time from the free-text conversation.
   - **Find Records** (Zapier Tables) — searches the **Appointments** table for an existing row matching the same Doctor + Date + Time (the table has a composite `SlotKey` column, e.g. `Dr. Sara|2026-08-25|3:00 PM`, used as the match key).
   - **Filter by Zapier** — only continues if the Find Records step returned **zero matches** (slot is free).
   - **Create Record** (Zapier Tables) — writes the new appointment (Status = `Confirmed`) if the Filter passed.
4. **Available slot** → bot asks for/confirms remaining details (name, phone, reason), user types `CONFIRM` or clicks the Confirm button, Zap creates the record, and the bot replies with a booking-confirmed summary.
5. **Taken slot** → the Filter blocks Create Record; the bot instead replies with the exact configured fallback: *"That slot is unavailable. Would you like 3 PM or 5 PM instead?"* and continues the conversation to book one of those alternatives instead.

## 🔧 Configuration

- **AI extraction:** a single **AI by Zapier** "Analyse and Return Data" step pulls doctor, date (relative → absolute), and time out of the free-text chat message in one pass.
- **Availability search key:** a composite `SlotKey` field (`Doctor|Date|Time`, e.g. `Dr. Ahmed|2026-08-25|11:00 PM`) rather than matching three separate columns — this is what Find Records searches against.
- **Filter condition:** proceed to Create Record only when Find Records' result count = 0.
- **Alternative-slot suggestion:** fixed fallback times — always offers **3 PM or 5 PM** regardless of what was actually booked, per the exact literal wording the roadmap specifies (this is a static suggestion, not dynamically computed from real open slots).
- **Knowledge sync:** the Appointments table is set to **Daily sync** as a knowledge source, so the bot's own awareness of existing bookings can be up to a day stale relative to the live table (the actual availability check still queries the live table via Find Records inside the Zap, so booking correctness isn't affected — only the bot's conversational awareness could lag).

## 🧪 Test Input & Output

Actual verified runs:

| Scenario               | Input                                                                                                                                                            | Output                                                                                                                                                                                                                                                                                                                                       |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Happy path             | "Book Dr. Ahmed tomorrow at 11 PM for a general checkup" (name Usman Shakeel, phone provided)                                                                    | Bot confirmed details → user typed`CONFIRM` → *"Your appointment is confirmed: Usman Shakeel — Dr. Ahmed, August 25, 2026 at 11:00 PM, Reason: General checkup"* — `APT-1234` created, Status `Confirmed`. **Date conversion verified correct:** test run on Aug 24, 2026; "tomorrow" resolved to the actual Aug 25, 2026. |
| Double-booking blocked | "I want to meet Dr Sara for Skin allergy test tommorow at 4 pm name Faizan Saeed phone 03012345675" (Dr. Sara already booked 2026-08-25 4:00 PM by Farhat Nawab) | *"That slot is unavailable. Would you like 3 PM or 5 PM instead?"* — exact match to the roadmap's required response text; no record created for the conflicting slot                                                                                                                                                                      |
| Alternative accepted   | User replied "at 3 pm" to the offered alternatives                                                                                                               | New record created:`APT-1023`, Faizan Saeed, Dr. Sara, 2026-08-25, 3:00 PM, Skin allergy test, Status `Confirmed` — see [`Alternate Time Slot record.png`](<screenshots/Alternate%20Time%20Slot%20record.png>)                                                                                                                         |

Final **Appointments** table state (4 confirmed rows) after testing:

| Appointment ID | Patient       | Doctor    | Date       | Time     | Reason               |
| -------------- | ------------- | --------- | ---------- | -------- | -------------------- |
| APT-1234       | Usman Shakeel | Dr. Ahmed | 2026-08-25 | 11:00 PM | General checkup      |
| APT-2026       | Farhat Nawab  | Dr. Sara  | 2026-08-25 | 4:00 PM  | Skin allergy checkup |
| APT-08852      | Atif Hussain  | Dr. Ahmed | 2026-08-25 | 10:00 AM | General checkup      |
| APT-1023       | Faizan Saeed  | Dr. Sara  | 2026-08-25 | 3:00 PM  | Skin allergy test    |

## 🖼️ Screenshots

All screenshots live in [`screenshots/`](screenshots/):

- **Workflow:** [`Appointment Booking Zap.png`](<Appointment%20Booking%20Zap.png>) (project root — Chatbot Button Click → AI by Zapier → Find Records → Filter → Create Record)
- **Chatbot config:** [`Automation on Button Click.png`](<screenshots/Automation%20on%20Button%20Click.png>), [`Sync KB.png`](<screenshots/Sync%20KB.png>)
- **Doctor roster source:** [`Clinic Doctor Roster.txt`](<Clinic%20Doctor%20Roster.txt>) (project root)
- **Test run:** [`Chatbot Response on Booking.png`](<screenshots/Chatbot%20Response%20on%20Booking.png>), [`Prevents Double Booking.png`](<screenshots/Prevents%20Double%20Booking.png>) (blocked + alternatives), [`Alternate Time Slot record.png`](<screenshots/Alternate%20Time%20Slot%20record.png>) (record created after accepting the offered 3 PM alternative)
- **Table:** [`Appointments LHS.png`](<screenshots/Appointments%20LHS.png>), [`Appointments RHS.png`](<screenshots/Appointments%20RHS.png>)
