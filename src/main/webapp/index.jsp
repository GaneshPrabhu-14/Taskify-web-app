<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="theme-color" content="#f5f6f0">
	<title>Taskify | Make room for what matters</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
	<style>
		:root {
			color-scheme: light;
			--ink: #202a27;
			--muted: #7b8580;
			--line: #e7eae3;
			--paper: #f5f6f0;
			--white: #fff;
			--green: #315f4c;
			--green-dark: #214637;
			--mint: #e1eee3;
			--coral: #de795f;
			--yellow: #f1c86e;
			--shadow: 0 22px 70px rgba(31, 48, 39, .08);
			font-family: "DM Sans", "Trebuchet MS", sans-serif;
			color: var(--ink);
			background: var(--paper);
		}
		* { box-sizing: border-box; }
		body { margin: 0; min-height: 100vh; }
		button, input, select { font: inherit; }
		button { cursor: pointer; }
		.hidden { display: none !important; }
		.auth-screen { min-height: 100vh; display: grid; grid-template-columns: minmax(360px, .92fr) 1.08fr; background: #fbfcf8; }
		.auth-art { position: relative; overflow: hidden; display: flex; flex-direction: column; justify-content: space-between; padding: 42px clamp(32px, 6vw, 88px); color: #f7f7ef; background: var(--green-dark); }
		.auth-art::before, .auth-art::after { content: ""; position: absolute; border: 1px solid rgba(255,255,255,.14); border-radius: 50%; pointer-events: none; }
		.auth-art::before { width: 590px; height: 590px; right: -235px; top: 14%; }
		.auth-art::after { width: 410px; height: 410px; right: -145px; top: 24%; }
		.brand { display: inline-flex; align-items: center; gap: 11px; font-family: Manrope, sans-serif; font-weight: 800; font-size: 21px; letter-spacing: 0; }
		.brand-mark { width: 31px; height: 31px; display: grid; place-items: center; border-radius: 9px; color: var(--green-dark); background: var(--yellow); font-size: 18px; font-weight: 800; }
		.art-copy { position: relative; z-index: 1; max-width: 440px; margin: auto 0; padding: 65px 0; }
		.eyebrow { margin: 0 0 18px; color: #bad2c1; font-size: 11px; font-weight: 700; letter-spacing: 1.8px; text-transform: uppercase; }
		.art-copy h1 { margin: 0; max-width: 430px; font-family: Manrope, sans-serif; font-size: clamp(38px, 5vw, 62px); line-height: 1.08; letter-spacing: 0; }
		.art-copy p { max-width: 350px; margin: 22px 0 0; color: #c7d6cd; font-size: 15px; line-height: 1.8; }
		.art-foot { position: relative; z-index: 1; display: flex; align-items: center; gap: 12px; color: #c7d6cd; font-size: 12px; }
		.avatar-stack { display: flex; padding-left: 2px; }
		.avatar-stack span { width: 25px; height: 25px; margin-left: -3px; display: grid; place-items: center; border: 2px solid var(--green-dark); border-radius: 50%; color: var(--green-dark); background: #e4c099; font-size: 9px; font-weight: 700; }
		.avatar-stack span:nth-child(2) { background: #c6d9c6; }
		.avatar-stack span:nth-child(3) { background: #e6a28c; }
		.auth-main { display: grid; place-items: center; padding: 42px 26px; }
		.auth-box { width: min(100%, 410px); animation: rise .45s ease both; }
		.mobile-brand { display: none; color: var(--green-dark); margin-bottom: 40px; }
		.auth-box h2 { margin: 0; font-family: Manrope, sans-serif; font-size: 32px; letter-spacing: 0; }
		.auth-intro { margin: 9px 0 29px; color: var(--muted); font-size: 14px; }
		.auth-tabs { display: grid; grid-template-columns: 1fr 1fr; padding: 4px; margin-bottom: 25px; border-radius: 9px; background: #f0f2ec; }
		.auth-tabs button { padding: 10px; border: 0; border-radius: 7px; color: #778079; background: transparent; font-size: 13px; font-weight: 600; }
		.auth-tabs button.active { color: var(--ink); background: var(--white); box-shadow: 0 2px 8px rgba(30, 45, 35, .08); }
		.field { display: grid; gap: 8px; margin-bottom: 17px; }
		.field label { color: #414b46; font-size: 12px; font-weight: 700; }
		.field input, .composer input, .composer select, .search input { min-width: 0; outline: 0; border: 1px solid #dfe4dc; color: var(--ink); background: #fff; transition: border-color .16s, box-shadow .16s; }
		.field input { width: 100%; height: 46px; padding: 0 13px; border-radius: 7px; font-size: 14px; }
		.field input:focus, .composer input:focus, .composer select:focus, .search:focus-within { border-color: #6c927b; box-shadow: 0 0 0 3px rgba(82, 129, 99, .12); }
		.primary-btn { width: 100%; min-height: 47px; margin-top: 5px; border: 0; border-radius: 7px; color: #fff; background: var(--green); font-size: 14px; font-weight: 700; transition: background .18s, transform .18s; }
		.primary-btn:hover { background: var(--green-dark); transform: translateY(-1px); }
		.form-message { min-height: 18px; margin: 12px 0 0; color: #b14e3e; font-size: 12px; }
		.auth-note { margin: 14px 0 0; color: #8b948e; font-size: 11px; line-height: 1.6; text-align: center; }
		.app { min-height: 100vh; display: grid; grid-template-columns: 238px minmax(0, 1fr); }
		.sidebar { display: flex; flex-direction: column; padding: 27px 18px 19px; border-right: 1px solid var(--line); background: #fbfcf8; }
		.sidebar .brand { padding: 0 11px 36px; color: var(--green-dark); }
		.side-label { margin: 0 10px 10px; color: #a0a8a1; font-size: 10px; font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; }
		.nav-list { display: grid; gap: 4px; }
		.nav-item { display: flex; align-items: center; gap: 11px; width: 100%; min-height: 40px; padding: 0 11px; border: 0; border-radius: 7px; color: #64706a; background: transparent; text-align: left; font-size: 13px; font-weight: 600; }
		.nav-item:hover { background: #f1f4ee; }
		.nav-item.active { color: var(--green-dark); background: var(--mint); }
		.nav-icon { width: 18px; color: #87948b; text-align: center; font-size: 15px; }
		.nav-item.active .nav-icon { color: var(--green); }
		.nav-count { margin-left: auto; color: #7e8981; font-size: 11px; }
		.sidebar-rule { height: 1px; margin: 25px 8px 22px; background: var(--line); }
		.category-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--dot); }
		.sidebar-bottom { margin-top: auto; }
		.profile { display: flex; align-items: center; gap: 10px; padding: 16px 8px 3px; border-top: 1px solid var(--line); }
		.profile-avatar { width: 34px; height: 34px; display: grid; flex: 0 0 auto; place-items: center; border-radius: 50%; color: #315f4c; background: #dce9dc; font-size: 12px; font-weight: 700; }
		.profile-name { min-width: 0; flex: 1; overflow: hidden; font-size: 12px; font-weight: 700; text-overflow: ellipsis; white-space: nowrap; }
		.profile-email { display: block; margin-top: 3px; color: var(--muted); font-size: 10px; font-weight: 400; }
		.text-button { padding: 7px 0 7px 5px; border: 0; color: #7c8780; background: transparent; font-size: 11px; }
		.main { min-width: 0; padding: 39px clamp(24px, 5vw, 68px) 60px; }
		.topbar { display: flex; align-items: center; justify-content: space-between; gap: 20px; margin-bottom: 35px; }
		.date-line { color: #838d86; font-size: 12px; }
		.greeting { margin: 8px 0 0; font-family: Manrope, sans-serif; font-size: 29px; line-height: 1.25; letter-spacing: 0; }
		.greeting span { color: var(--green); }
		.search { width: min(245px, 35vw); height: 39px; display: flex; align-items: center; gap: 8px; padding: 0 11px; border: 1px solid var(--line); border-radius: 7px; background: #fff; }
		.search span { color: #849087; font-size: 15px; }
		.search input { width: 100%; padding: 0; border: 0; box-shadow: none !important; font-size: 12px; }
		.summary { display: grid; grid-template-columns: minmax(0, 1.45fr) minmax(220px, .8fr); gap: 14px; margin-bottom: 32px; }
		.focus-panel { min-height: 147px; display: flex; align-items: center; justify-content: space-between; gap: 18px; overflow: hidden; padding: 22px 25px; border-radius: 9px; color: #f6f8f1; background: var(--green); }
		.focus-panel h3 { margin: 0 0 7px; font-family: Manrope, sans-serif; font-size: 18px; letter-spacing: 0; }
		.focus-panel p { margin: 0; color: #d0e0d3; font-size: 12px; }
		.progress-ring { position: relative; width: 82px; height: 82px; flex: 0 0 auto; display: grid; place-items: center; border-radius: 50%; background: conic-gradient(var(--yellow) 0deg, var(--yellow) var(--progress), rgba(255,255,255,.2) var(--progress), rgba(255,255,255,.2) 360deg); }
		.progress-ring::before { content: ""; position: absolute; width: 64px; height: 64px; border-radius: 50%; background: var(--green); }
		.progress-ring span { position: relative; z-index: 1; font-size: 14px; font-weight: 700; }
		.stat-panel { display: flex; flex-direction: column; justify-content: center; padding: 20px 23px; border: 1px solid var(--line); border-radius: 9px; background: rgba(255,255,255,.7); }
		.stat-panel span { color: var(--muted); font-size: 11px; }
		.stat-panel strong { margin: 6px 0 3px; font-family: Manrope, sans-serif; font-size: 31px; letter-spacing: 0; }
		.stat-panel small { color: #9ba39d; font-size: 10px; }
		.section-head { display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 15px; }
		.section-head h2 { margin: 0; font-family: Manrope, sans-serif; font-size: 17px; letter-spacing: 0; }
		.section-head h2 span { margin-left: 7px; color: #9ba39d; font-family: "DM Sans", sans-serif; font-size: 11px; font-weight: 500; }
		.list-filters { display: flex; align-items: center; gap: 4px; }
		.filter-btn { padding: 7px 10px; border: 0; border-radius: 6px; color: #818b84; background: transparent; font-size: 11px; font-weight: 600; }
		.filter-btn.active { color: var(--green-dark); background: #e6eee6; }
		.composer { display: grid; grid-template-columns: minmax(150px, 1fr) 128px 137px 82px; gap: 8px; margin-bottom: 18px; }
		.composer input, .composer select { height: 40px; padding: 0 11px; border-radius: 6px; font-size: 12px; }
		.composer select { color: #59645d; }
		.add-btn { border: 0; border-radius: 6px; color: #fff; background: var(--coral); font-size: 12px; font-weight: 700; transition: background .18s; }
		.add-btn:hover { background: #c9664c; }
		.task-list { display: grid; gap: 8px; }
		.task-row { min-height: 70px; display: grid; grid-template-columns: 22px minmax(0, 1fr) auto auto; align-items: center; gap: 13px; padding: 12px 15px; border: 1px solid #e8ebe5; border-radius: 7px; background: rgba(255,255,255,.82); animation: rise .28s ease both; }
		.task-check { width: 17px; height: 17px; margin: 0; accent-color: var(--green); cursor: pointer; }
		.task-title { overflow-wrap: anywhere; font-size: 13px; font-weight: 600; }
		.task-row.done .task-title { color: #a0a8a1; text-decoration: line-through; }
		.task-meta { display: flex; align-items: center; gap: 9px; margin-top: 6px; color: #929b94; font-size: 10px; }
		.tag { padding: 4px 8px; border-radius: 20px; color: var(--tag-ink); background: var(--tag-bg); font-size: 10px; font-weight: 600; white-space: nowrap; }
		.task-date { color: #818b84; font-size: 10px; white-space: nowrap; }
		.task-date.overdue { color: #bd5e4a; }
		.delete-btn { padding: 7px 8px; border: 0; border-radius: 5px; color: #a0a8a1; background: transparent; font-size: 11px; }
		.delete-btn:hover { color: #b64f3a; background: #fbefeb; }
		.empty-state { padding: 45px 20px; border: 1px dashed #dce2d9; border-radius: 8px; color: #7d8981; text-align: center; }
		.empty-state strong { display: block; margin-bottom: 6px; color: #48554d; font-size: 13px; }
		.empty-state span { font-size: 12px; }
		.toast { position: fixed; right: 24px; bottom: 24px; z-index: 5; padding: 12px 16px; border-radius: 7px; color: #fff; background: #283c32; box-shadow: var(--shadow); font-size: 12px; animation: rise .2s ease both; }
		@keyframes rise { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
		@media (max-width: 900px) {
			.app { grid-template-columns: 205px minmax(0, 1fr); }
			.main { padding: 30px 25px 45px; }
			.summary { grid-template-columns: 1fr; }
			.stat-panel { min-height: 95px; }
		}
		@media (max-width: 680px) {
			.auth-screen { grid-template-columns: 1fr; }
			.auth-art { display: none; }
			.auth-main { min-height: 100vh; align-items: start; padding: 35px 24px; }
			.mobile-brand { display: inline-flex; }
			.auth-box { margin-top: 7vh; }
			.app { display: block; padding-bottom: 67px; }
			.sidebar { position: fixed; z-index: 4; right: 0; bottom: 0; left: 0; height: 62px; display: block; padding: 0 8px; border-top: 1px solid var(--line); border-right: 0; background: #fbfcf8; }
			.sidebar .brand, .side-label, .sidebar-rule, .category-nav, .sidebar-bottom { display: none; }
			.nav-list { height: 100%; display: grid; grid-template-columns: repeat(3, 1fr); align-items: center; }
			.nav-item { min-height: 48px; flex-direction: column; justify-content: center; gap: 2px; padding: 4px; font-size: 10px; }
			.nav-icon { font-size: 16px; }
			.nav-count { display: none; }
			.main { padding: 28px 17px 30px; }
			.topbar { align-items: flex-start; margin-bottom: 25px; }
			.greeting { font-size: 24px; }
			.search { width: 40px; flex: 0 0 40px; padding: 0 11px; }
			.search input { width: 0; }
			.search:focus-within { position: absolute; right: 17px; width: min(250px, calc(100vw - 34px)); z-index: 2; }
			.search:focus-within input { width: 100%; }
			.focus-panel { min-height: 130px; padding: 18px; }
			.progress-ring { width: 69px; height: 69px; }
			.progress-ring::before { width: 53px; height: 53px; }
			.composer { grid-template-columns: minmax(0, 1fr) 100px; }
			.composer input { grid-column: 1 / -1; }
			.composer select { width: 100%; }
			.add-btn { min-height: 40px; }
			.section-head { align-items: flex-start; flex-direction: column; gap: 10px; }
			.list-filters { width: 100%; overflow-x: auto; }
			.filter-btn { flex: 0 0 auto; }
			.task-row { grid-template-columns: 19px minmax(0, 1fr) auto; gap: 10px; padding: 12px 10px; }
			.task-date { grid-column: 2; grid-row: 2; margin-top: -3px; }
			.task-content { grid-column: 2; grid-row: 1; }
			.delete-btn { grid-column: 3; grid-row: 1 / span 2; }
		}
		@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation-duration: .01ms !important; animation-iteration-count: 1 !important; scroll-behavior: auto !important; transition-duration: .01ms !important; } }
	</style>
</head>
<body>
	<section class="auth-screen" id="authScreen">
		<aside class="auth-art">
			<div class="brand"><span class="brand-mark">T</span> taskify</div>
			<div class="art-copy">
				<p class="eyebrow">A clearer kind of productive</p>
				<h1>Make room for what matters.</h1>
				<p>Bring the little things together, sort them by what they need, and give your day a little more breathing room.</p>
			</div>
			<div class="art-foot"><span class="avatar-stack"><span>J</span><span>M</span><span>A</span></span><span>A good day starts with one small thing.</span></div>
		</aside>
		<main class="auth-main">
			<div class="auth-box">
				<div class="brand mobile-brand"><span class="brand-mark">T</span> taskify</div>
				<h2 id="authTitle">Welcome back</h2>
				<p class="auth-intro" id="authIntro">Sign in to pick up where you left off.</p>
				<div class="auth-tabs" role="tablist" aria-label="Account access">
					<button class="active" type="button" data-auth-mode="login" role="tab" aria-selected="true">Log in</button>
					<button type="button" data-auth-mode="register" role="tab" aria-selected="false">Create account</button>
				</div>
				<form id="authForm">
					<div class="field hidden" id="nameField"><label for="displayName">Your name</label><input id="displayName" name="displayName" autocomplete="name" placeholder="Jamie Parker" maxlength="50"></div>
					<div class="field"><label for="email">Email address</label><input id="email" name="email" type="email" autocomplete="email" placeholder="you@example.com" required></div>
					<div class="field"><label for="password">Password</label><input id="password" name="password" type="password" autocomplete="current-password" placeholder="At least 8 characters" minlength="8" required></div>
					<button class="primary-btn" id="authSubmit" type="submit">Log in</button>
					<p class="form-message" id="authMessage" aria-live="polite"></p>
				</form>
				<p class="auth-note">Your account and tasks are stored in your Taskify database.</p>
			</div>
		</main>
	</section>

	<div class="app hidden" id="taskApp">
		<aside class="sidebar">
			<div class="brand"><span class="brand-mark">T</span> taskify</div>
			<p class="side-label">Workspace</p>
			<nav class="nav-list" id="mainNav" aria-label="Task views">
				<button class="nav-item active" type="button" data-view="all"><span class="nav-icon">▤</span>All tasks<span class="nav-count" id="allCount">0</span></button>
				<button class="nav-item" type="button" data-view="today"><span class="nav-icon">◷</span>Today<span class="nav-count" id="todayCount">0</span></button>
				<button class="nav-item" type="button" data-view="upcoming"><span class="nav-icon">▦</span>Upcoming</button>
			</nav>
			<div class="sidebar-rule"></div>
			<p class="side-label">Categories</p>
			<nav class="nav-list category-nav" id="categoryNav" aria-label="Task categories">
				<button class="nav-item" type="button" data-view="Work"><span class="category-dot" style="--dot:#648c71"></span>Work</button>
				<button class="nav-item" type="button" data-view="Personal"><span class="category-dot" style="--dot:#d78269"></span>Personal</button>
				<button class="nav-item" type="button" data-view="Study"><span class="category-dot" style="--dot:#d3a844"></span>Study</button>
				<button class="nav-item" type="button" data-view="Health"><span class="category-dot" style="--dot:#7b88ad"></span>Health</button>
			</nav>
			<div class="sidebar-bottom"><div class="profile"><div class="profile-avatar" id="profileAvatar">T</div><div class="profile-name"><span id="profileName">Taskify user</span><span class="profile-email" id="profileEmail"></span></div><button class="text-button" type="button" id="logoutButton" title="Log out">Log out</button></div></div>
		</aside>
		<main class="main">
			<header class="topbar">
				<div><div class="date-line" id="dateLine"></div><h1 class="greeting">Good to see you, <span id="greetingName">there</span>.</h1></div>
				<label class="search"><span aria-hidden="true">⌕</span><input id="searchInput" type="search" placeholder="Search tasks" aria-label="Search tasks"></label>
			</header>
			<section class="summary" aria-label="Task overview">
				<div class="focus-panel"><div><h3 id="focusHeading">A little progress adds up.</h3><p id="focusCopy">Your day is yours to shape. Start with one task.</p></div><div class="progress-ring" id="progressRing" style="--progress:0deg"><span id="progressText">0%</span></div></div>
				<div class="stat-panel"><span>Open tasks</span><strong id="openCount">0</strong><small id="doneCopy">Nothing checked off yet</small></div>
			</section>
			<section aria-labelledby="tasksHeading">
				<div class="section-head"><h2 id="tasksHeading">All tasks <span id="viewCount">0 tasks</span></h2><div class="list-filters" id="statusFilters" aria-label="Filter tasks">
					<button class="filter-btn active" type="button" data-status="active">To do</button>
					<button class="filter-btn" type="button" data-status="all">Everything</button>
					<button class="filter-btn" type="button" data-status="done">Completed</button>
				</div></div>
				<form class="composer" id="taskForm">
					<input id="taskTitle" type="text" placeholder="What needs to get done?" maxlength="120" aria-label="Task name" required>
					<select id="taskCategory" aria-label="Task category"><option>Work</option><option>Personal</option><option>Study</option><option>Health</option></select>
					<input id="taskDue" type="date" aria-label="Due date">
					<button class="add-btn" type="submit">+ Add task</button>
				</form>
				<div class="task-list" id="taskList" aria-live="polite"></div>
			</section>
		</main>
	</div>
	<div class="toast hidden" id="toast" role="status"></div>

	<script>
		(() => {
			const apiBase = "<%= request.getContextPath() %>/api";
			const categories = {
				Work: { bg: "#e5eee6", ink: "#45694f", dot: "#648c71" },
				Personal: { bg: "#f8e9e4", ink: "#aa604d", dot: "#d78269" },
				Study: { bg: "#f6efd9", ink: "#94752b", dot: "#d3a844" },
				Health: { bg: "#e9ebf4", ink: "#5f6b91", dot: "#7b88ad" }
			};
			const authScreen = document.getElementById("authScreen");
			const taskApp = document.getElementById("taskApp");
			const authForm = document.getElementById("authForm");
			const authMessage = document.getElementById("authMessage");
			const taskForm = document.getElementById("taskForm");
			const taskList = document.getElementById("taskList");
			let authMode = "login";
			let currentUser = null;
			let tasks = [];
			let currentView = "all";
			let currentStatus = "active";
			let searchText = "";
			let toastTimer;

			async function apiRequest(path, options = {}) {
				const response = await fetch(path, {
					credentials: "same-origin",
					headers: { "Content-Type": "application/json", ...options.headers },
					...options
				});
				const result = await response.json().catch(() => ({}));
				if (!response.ok) throw new Error(result.error || "Something went wrong. Please try again.");
				return result;
			}
			async function refreshTasks() {
				const result = await apiRequest(`${apiBase}/tasks`);
				tasks = result.tasks;
				render();
			}
			function localDateKey(date = new Date()) {
				const month = String(date.getMonth() + 1).padStart(2, "0");
				const day = String(date.getDate()).padStart(2, "0");
				return `${date.getFullYear()}-${month}-${day}`;
			}
			function escapeHtml(value) {
				return String(value).replace(/[&<>"']/g, character => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[character]);
			}
			function setAuthMode(mode) {
				authMode = mode;
				const registering = mode === "register";
				document.getElementById("authTitle").textContent = registering ? "Create your account" : "Welcome back";
				document.getElementById("authIntro").textContent = registering ? "A calmer to-do list is a minute away." : "Sign in to pick up where you left off.";
				document.getElementById("authSubmit").textContent = registering ? "Create account" : "Log in";
				document.getElementById("nameField").classList.toggle("hidden", !registering);
				document.getElementById("displayName").required = registering;
				document.getElementById("password").autocomplete = registering ? "new-password" : "current-password";
				authMessage.textContent = "";
				document.querySelectorAll("[data-auth-mode]").forEach(button => {
					const active = button.dataset.authMode === mode;
					button.classList.toggle("active", active);
					button.setAttribute("aria-selected", String(active));
				});
			}
			async function showApp(user) {
				currentUser = user;
				document.getElementById("profileName").textContent = user.name;
				document.getElementById("profileEmail").textContent = user.email;
				document.getElementById("profileAvatar").textContent = user.name.trim().charAt(0).toUpperCase() || "T";
				document.getElementById("greetingName").textContent = user.name.trim().split(/\s+/)[0] || "there";
				authScreen.classList.add("hidden");
				taskApp.classList.remove("hidden");
				document.getElementById("dateLine").textContent = new Intl.DateTimeFormat(undefined, { weekday: "long", month: "long", day: "numeric" }).format(new Date());
				try { await refreshTasks(); }
				catch (error) { showToast(error.message); }
			}
			async function signOut() {
				try { await apiRequest(`${apiBase}/auth/logout`, { method: "POST" }); }
				catch (error) { showToast(error.message); return; }
				currentUser = null;
				tasks = [];
				taskApp.classList.add("hidden");
				authScreen.classList.remove("hidden");
				authForm.reset();
				setAuthMode("login");
			}
			function formatDue(date) {
				if (!date) return "No due date";
				const today = new Date();
				today.setHours(0, 0, 0, 0);
				const due = new Date(date + "T00:00:00");
				const days = Math.round((due - today) / 86400000);
				if (days === 0) return "Due today";
				if (days === 1) return "Due tomorrow";
				return "Due " + new Intl.DateTimeFormat(undefined, { month: "short", day: "numeric" }).format(due);
			}
			function filteredTasks() {
				const today = new Date();
				today.setHours(0, 0, 0, 0);
				return tasks.filter(task => {
					if (currentStatus === "active" && task.done) return false;
					if (currentStatus === "done" && !task.done) return false;
					  if (currentView === "today" && task.due !== localDateKey()) return false;
					if (currentView === "upcoming" && (!task.due || new Date(task.due + "T00:00:00") <= today || task.done)) return false;
					if (!["all", "today", "upcoming"].includes(currentView) && task.category !== currentView) return false;
					return task.title.toLowerCase().includes(searchText);
				}).sort((a, b) => Number(a.done) - Number(b.done) || (a.due || "9999-99-99").localeCompare(b.due || "9999-99-99") || b.createdAt - a.createdAt);
			}
			function render() {
				const openTasks = tasks.filter(task => !task.done);
				const doneTasks = tasks.filter(task => task.done);
				const todayKey = localDateKey();
				document.getElementById("allCount").textContent = openTasks.length;
				document.getElementById("todayCount").textContent = openTasks.filter(task => task.due === todayKey).length;
				document.getElementById("openCount").textContent = openTasks.length;
				document.getElementById("doneCopy").textContent = doneTasks.length ? `${doneTasks.length} ${doneTasks.length === 1 ? "task" : "tasks"} completed` : "Nothing checked off yet";
				const completion = tasks.length ? Math.round(doneTasks.length / tasks.length * 100) : 0;
				document.getElementById("progressRing").style.setProperty("--progress", `${completion * 3.6}deg`);
				document.getElementById("progressText").textContent = `${completion}%`;
				document.getElementById("focusHeading").textContent = openTasks.length ? "One thing at a time." : "You have room to breathe.";
				document.getElementById("focusCopy").textContent = openTasks.length ? `${openTasks.length} ${openTasks.length === 1 ? "task is" : "tasks are"} waiting when you're ready.` : "Your list is clear. Enjoy the little win.";
				const headings = { all: "All tasks", today: "Today", upcoming: "Upcoming", Work: "Work", Personal: "Personal", Study: "Study", Health: "Health" };
				document.getElementById("tasksHeading").childNodes[0].textContent = headings[currentView] + " ";
				const visible = filteredTasks();
				document.getElementById("viewCount").textContent = `${visible.length} ${visible.length === 1 ? "task" : "tasks"}`;
				taskList.innerHTML = "";
				if (!visible.length) {
					const message = searchText ? "Try another search" : currentStatus === "done" ? "No completed tasks yet" : currentStatus === "active" && tasks.length ? "Nothing on this list" : "Your list is clear";
					const detail = searchText ? "No tasks match that phrase." : currentStatus === "active" && tasks.length ? "Try another view or add a task above." : "Add a task above and it will show up here.";
					taskList.innerHTML = `<div class="empty-state"><strong>${message}</strong><span>${detail}</span></div>`;
					return;
				}
				visible.forEach(task => {
					const tag = categories[task.category] || categories.Work;
					const dueDate = task.due ? new Date(task.due + "T00:00:00") : null;
					const today = new Date(); today.setHours(0, 0, 0, 0);
					const overdue = dueDate && dueDate < today && !task.done;
					const row = document.createElement("article");
					row.className = `task-row${task.done ? " done" : ""}`;
					row.innerHTML = `<input class="task-check" type="checkbox" aria-label="Mark ${escapeHtml(task.title)} ${task.done ? "not complete" : "complete"}" ${task.done ? "checked" : ""}><div class="task-content"><div class="task-title">${escapeHtml(task.title)}</div><div class="task-meta"><span class="tag" style="--tag-bg:${tag.bg};--tag-ink:${tag.ink}">${escapeHtml(task.category)}</span></div></div><span class="task-date${overdue ? " overdue" : ""}">${escapeHtml(formatDue(task.due))}</span><button class="delete-btn" type="button" aria-label="Delete ${escapeHtml(task.title)}">Delete</button>`;
						row.querySelector(".task-check").addEventListener("change", async () => {
							const done = !task.done;
							try {
								await apiRequest(`${apiBase}/tasks/${encodeURIComponent(task.id)}`, { method: "PUT", body: JSON.stringify({ done }) });
								await refreshTasks();
								showToast(done ? "Task completed" : "Task reopened");
							} catch (error) { showToast(error.message); }
					});
						row.querySelector(".delete-btn").addEventListener("click", async () => {
							try {
								await apiRequest(`${apiBase}/tasks/${encodeURIComponent(task.id)}`, { method: "DELETE" });
								await refreshTasks();
								showToast("Task deleted");
							} catch (error) { showToast(error.message); }
					});
					taskList.appendChild(row);
				});
			}
			function showToast(message) {
				const toast = document.getElementById("toast");
				toast.textContent = message;
				toast.classList.remove("hidden");
				clearTimeout(toastTimer);
				toastTimer = setTimeout(() => toast.classList.add("hidden"), 1800);
			}

			document.querySelectorAll("[data-auth-mode]").forEach(button => button.addEventListener("click", () => setAuthMode(button.dataset.authMode)));
			authForm.addEventListener("submit", async event => {
				event.preventDefault();
				const email = document.getElementById("email").value.trim().toLowerCase();
				const password = document.getElementById("password").value;
				const body = { email, password };
				if (authMode === "register") body.name = document.getElementById("displayName").value.trim();
				try {
					const route = authMode === "register" ? "register" : "login";
					const result = await apiRequest(`${apiBase}/auth/${route}`, { method: "POST", body: JSON.stringify(body) });
					await showApp(result.user);
					if (authMode === "register") showToast("Your account is ready");
				} catch (error) { authMessage.textContent = error.message; }
			});
			taskForm.addEventListener("submit", async event => {
				event.preventDefault();
				const title = document.getElementById("taskTitle").value.trim();
				if (!title) return;
				const body = { title, category: document.getElementById("taskCategory").value, due: document.getElementById("taskDue").value };
				try {
					await apiRequest(`${apiBase}/tasks`, { method: "POST", body: JSON.stringify(body) });
					taskForm.reset();
					document.getElementById("taskTitle").focus();
					await refreshTasks(); showToast("Task added");
				} catch (error) { showToast(error.message); }
			});
			document.getElementById("mainNav").addEventListener("click", event => {
				const button = event.target.closest("[data-view]");
				if (!button) return;
				currentView = button.dataset.view;
				document.querySelectorAll("#mainNav .nav-item, #categoryNav .nav-item").forEach(item => item.classList.toggle("active", item === button));
				render();
			});
			document.getElementById("categoryNav").addEventListener("click", event => {
				const button = event.target.closest("[data-view]");
				if (!button) return;
				currentView = button.dataset.view;
				document.querySelectorAll("#mainNav .nav-item, #categoryNav .nav-item").forEach(item => item.classList.toggle("active", item === button));
				render();
			});
			document.getElementById("statusFilters").addEventListener("click", event => {
				const button = event.target.closest("[data-status]");
				if (!button) return;
				currentStatus = button.dataset.status;
				document.querySelectorAll("[data-status]").forEach(item => item.classList.toggle("active", item === button));
				render();
			});
			document.getElementById("searchInput").addEventListener("input", event => {
				searchText = event.target.value.trim().toLowerCase();
				render();
			});
			document.getElementById("logoutButton").addEventListener("click", signOut);
			apiRequest(`${apiBase}/auth/session`).then(result => showApp(result.user)).catch(() => {});
		})();
	</script>
</body>
</html>
