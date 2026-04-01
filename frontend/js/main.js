/* ============================================================
   EMS Pro – main.js  (Shared utilities & interactions)
   ============================================================ */

'use strict';

// ── NAVBAR SCROLL EFFECT ──────────────────────────────────
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 10);
  }, { passive: true });
}

// ── HAMBURGER MENU ─────────────────────────────────────────
const hamburger = document.getElementById('hamburger');
const sidebar   = document.querySelector('.sidebar');
if (hamburger && sidebar) {
  hamburger.addEventListener('click', () => {
    sidebar.classList.toggle('open');
  });
  document.addEventListener('click', e => {
    if (sidebar.classList.contains('open') &&
        !sidebar.contains(e.target) &&
        !hamburger.contains(e.target)) {
      sidebar.classList.remove('open');
    }
  });
}

// ── FEATURE CARD ANIMATION ─────────────────────────────────
const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const delay = entry.target.dataset.delay || 0;
      entry.target.style.animationDelay = delay + 'ms';
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.feat-card, .step').forEach(el => observer.observe(el));

// ── TOAST NOTIFICATIONS ────────────────────────────────────
function showToast(message, type = 'success', duration = 3000) {
  let container = document.querySelector('.toast-container');
  if (!container) {
    container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
  }
  const icons = { success: '✓', error: '✕', warning: '⚠' };
  const toast = document.createElement('div');
  toast.className = `toast ${type}`;
  toast.innerHTML = `<span>${icons[type] || '✓'}</span> ${message}`;
  container.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(24px)';
    toast.style.transition = '.3s';
    setTimeout(() => toast.remove(), 300);
  }, duration);
}
window.showToast = showToast;

// ── MODAL HELPERS ──────────────────────────────────────────
function openModal(id) {
  const m = document.getElementById(id);
  if (m) { m.classList.add('open'); document.body.style.overflow = 'hidden'; }
}
function closeModal(id) {
  const m = document.getElementById(id);
  if (m) { m.classList.remove('open'); document.body.style.overflow = ''; }
}
window.openModal  = openModal;
window.closeModal = closeModal;

// Close modals on backdrop click
document.addEventListener('click', e => {
  if (e.target.classList.contains('modal-backdrop')) {
    e.target.classList.remove('open');
    document.body.style.overflow = '';
  }
});

// ── ACTIVE NAV LINK ────────────────────────────────────────
(function markActiveNav() {
  const path = window.location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.sidebar-nav a, .nav-links a').forEach(a => {
    if (a.getAttribute('href')?.includes(path)) a.classList.add('active');
  });
})();

// ── SEARCH UTILITY ─────────────────────────────────────────
function filterTable(inputId, tableId) {
  const inp = document.getElementById(inputId);
  const tbl = document.getElementById(tableId);
  if (!inp || !tbl) return;
  inp.addEventListener('input', () => {
    const q = inp.value.toLowerCase();
    tbl.querySelectorAll('tbody tr').forEach(row => {
      row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  });
}
window.filterTable = filterTable;

// ── AVATAR COLOR GENERATOR ─────────────────────────────────
const AVATAR_COLORS = ['#3B6FE4','#059669','#D97706','#DC2626','#7C3AED','#DB2777'];
function getAvatarColor(name) {
  let hash = 0;
  for (let i = 0; i < name.length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash);
  return AVATAR_COLORS[Math.abs(hash) % AVATAR_COLORS.length];
}
function makeAvatar(name, size = 36) {
  const initials = name.split(' ').map(w => w[0]).slice(0,2).join('').toUpperCase();
  const color = getAvatarColor(name);
  return `<div class="avatar" style="width:${size}px;height:${size}px;background:${color};font-size:${size*.35}px">${initials}</div>`;
}
window.makeAvatar = makeAvatar;

// ── FORMAT CURRENCY ────────────────────────────────────────
function formatINR(num) {
  return '₹' + Number(num).toLocaleString('en-IN');
}
window.formatINR = formatINR;

// ── FORMAT DATE ─────────────────────────────────────────────
function formatDate(dateStr) {
  if (!dateStr) return '—';
  const d = new Date(dateStr);
  return d.toLocaleDateString('en-IN', { day:'2-digit', month:'short', year:'numeric' });
}
window.formatDate = formatDate;

console.log('%c EMS Pro Frontend Loaded ✓', 'color:#3B6FE4;font-weight:bold;font-size:14px');
