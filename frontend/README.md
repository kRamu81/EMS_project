# EMS Pro – Employee Management System Frontend

**Phase 1 Frontend Submission | Blackbuck Engineers Pvt. Ltd.**

---

## 🗂 Project Structure

```
EMS_Frontend/
├── index.html              ← Landing / Home Page
├── css/
│   ├── main.css            ← Design system, shared components, sidebar layout
│   └── landing.css         ← Landing page specific styles
├── js/
│   └── main.js             ← Shared utilities (toast, modal, avatar, formatting)
├── pages/
│   ├── login.html          ← Login page (role-based: Admin / HR / Employee)
│   ├── dashboard.html      ← Main dashboard with stats, charts, quick actions
│   ├── employees.html      ← Employee list, search, filter, add/delete
│   ├── attendance.html     ← Daily attendance tracking + mini calendar
│   ├── leaves.html         ← Leave request management + approve/reject
│   └── salary.html         ← Payroll view, department bars, payslip modal
└── README.md
```

---

## 🚀 How to Run

1. **Download** and unzip `EMS_Frontend.zip`
2. **Open** `index.html` in any modern browser (Chrome, Firefox, Edge)
3. No build step required — pure HTML/CSS/JS

**To view all pages:**
- Landing: `index.html`
- Login: `pages/login.html` → use credentials below
- Dashboard: `pages/dashboard.html`

**Demo Login:**
| Role | Email | Password |
|---|---|---|
| Admin | rajesh.kumar@ems.com | admin123 |
| HR Manager | priya.sharma@ems.com | hr1234 |

---

## 🛠 Technologies Used

| Technology | Purpose |
|---|---|
| **HTML5** | Semantic page structure |
| **CSS3** | Design system, animations, responsive layout |
| **Vanilla JavaScript** | DOM manipulation, interactivity, data management |
| **Google Fonts** | DM Serif Display (headings) + DM Sans (body) |
| **CSS Custom Properties** | Consistent design tokens (colors, spacing, radii) |
| **CSS Grid & Flexbox** | Responsive layout system |
| **IntersectionObserver API** | Scroll-triggered animations |

> No external JS libraries used — fully dependency-free frontend.

---

## 📄 Pages & Features

### 🏠 Landing Page (`index.html`)
- Animated hero section with floating blobs and grid overlay
- Animated dashboard mockup preview
- Feature cards grid with hover effects and scroll animations
- 4-step "How it works" section
- Dark footer with module and tech stack links

### 🔐 Login Page (`pages/login.html`)
- Split-panel design (brand left, form right)
- Role switcher: Admin / HR Manager / Employee
- Form validation with toast notifications
- Credential-based authentication with redirect

### 📊 Dashboard (`pages/dashboard.html`)
- 4 KPI stat cards (employees, attendance, leaves, payroll)
- Dynamic bar chart (weekly attendance)
- Department donut chart (SVG-based)
- Recent activity feed
- Pending leave approvals with one-click actions
- Quick action buttons

### 👥 Employees (`pages/employees.html`)
- Full employee table with avatar generation
- Real-time search + department filter
- Add Employee modal with validated form
- Delete with confirmation
- Status badges (Active / On Leave / Inactive)

### 📅 Attendance (`pages/attendance.html`)
- Per-employee attendance table with inline status dropdowns
- Check-in / Check-out display
- Mini monthly calendar with color-coded attendance
- Summary stats cards

### 🌴 Leave Management (`pages/leaves.html`)
- Tabbed view: Pending / Approved / All
- One-click approve/reject with live state update
- Apply leave modal with date picker
- Leave type color badges (Sick, Casual, Earned, Unpaid)

### 💰 Payroll (`pages/salary.html`)
- Full salary table (basic + allowances + deductions = net)
- Department-wise animated progress bars
- Individual payslip modal with detailed breakdown
- Formatted Indian Rupee (₹) display

---

## 🎨 Design System

```css
--primary:       #3B6FE4   /* Brand blue */
--green:         #059669   /* Success / Present */
--amber:         #D97706   /* Warning / Pending */
--red:           #DC2626   /* Danger / Absent */
--purple:        #7C3AED   /* Accent / Payroll */

Font (Headings): DM Serif Display (Google Fonts)
Font (Body):     DM Sans (Google Fonts)
```

---

## ✅ Checklist

- [x] Functional multi-page frontend (6 pages)
- [x] Responsive design (mobile, tablet, desktop)
- [x] Role-based login with demo credentials
- [x] CRUD interactions (Add / Delete employees, Apply / Approve leaves)
- [x] Real-time search and filter
- [x] Toast notification system
- [x] Modal dialogs
- [x] Animated charts and statistics
- [x] Well-commented, organized code
- [x] No external dependencies

---

## 🔗 Backend Integration Plan

This frontend is designed to integrate with the Spring Boot backend:

| Frontend Action | API Endpoint (Planned) |
|---|---|
| Load employees | `GET /api/employees` |
| Add employee | `POST /api/employees` |
| Update employee | `PUT /api/employees/{id}` |
| Delete employee | `DELETE /api/employees/{id}` |
| Mark attendance | `POST /api/attendance` |
| Apply leave | `POST /api/leave-requests` |
| Approve leave | `PUT /api/leave-requests/{id}/approve` |
| Get salary | `GET /api/salaries/{employeeId}` |

---

*Submitted for Phase 1 – Frontend Development | EMS Pro | Blackbuck Engineers Pvt. Ltd.*
