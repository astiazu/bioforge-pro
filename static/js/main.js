// Main JavaScript for Portfolio Website
// José Luis Astiazu - Data Analysis Portfolio

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    initializeTooltips();
    
    // Add smooth scrolling
    addSmoothScrolling();
    
    // Initialize contact form
    initializeContactForm();
    
    // Add fade-in animations
    addFadeInAnimations();
    
    // Initialize interactive elements
    initializeInteractiveElements();
});

// Initialize Bootstrap tooltips
function initializeTooltips() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Add smooth scrolling for anchor links
function addSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Initialize contact form functionality
function initializeContactForm() {
    const contactForm = document.querySelector('form');
    if (contactForm && contactForm.querySelector('input[type="email"]')) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(this);
            const name = this.querySelector('input[type="text"]')?.value;
            const email = this.querySelector('input[type="email"]')?.value;
            const message = this.querySelector('textarea')?.value;
            
            if (validateContactForm(name, email, message)) {
                showSuccessMessage('¡Mensaje enviado! Te contactaré pronto.');
                this.reset();
            }
        });
    }
}

// Validate contact form
function validateContactForm(name, email, message) {
    if (!name || !email || !message) {
        showErrorMessage('Por favor completa todos los campos.');
        return false;
    }
    
    if (!isValidEmail(email)) {
        showErrorMessage('Por favor ingresa un email válido.');
        return false;
    }
    
    return true;
}

// Email validation helper
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Show success message
function showSuccessMessage(message) {
    showAlert(message, 'success');
}

// Show error message
function showErrorMessage(message) {
    showAlert(message, 'danger');
}

// Generic alert function
function showAlert(message, type) {
    const alertHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    
    // Insert alert at the top of the main content
    const mainContent = document.querySelector('.col-lg-9, .col-md-8');
    if (mainContent) {
        mainContent.insertAdjacentHTML('afterbegin', alertHTML);
        
        // Auto-dismiss after 5 seconds
        setTimeout(() => {
            const alert = mainContent.querySelector('.alert');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }
}

// Add fade-in animations
function addFadeInAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
            }
        });
    }, observerOptions);
    
    // Observe cards and sections
    document.querySelectorAll('.card, .row > .col-12').forEach(el => {
        observer.observe(el);
    });
}

// Initialize interactive elements
function initializeInteractiveElements() {
    // Add click effects to buttons
    document.querySelectorAll('.btn').forEach(button => {
        button.addEventListener('click', function(e) {
            // Create ripple effect
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });
    
    // Add hover effects to navigation links
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('mouseenter', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'translateX(5px)';
            }
        });
        
        link.addEventListener('mouseleave', function() {
            if (!this.classList.contains('active')) {
                this.style.transform = 'translateX(0)';
            }
        });
    });
}

// Subscription form handler
function handleSubscription() {
    const emailInput = document.querySelector('input[placeholder*="email"]');
    if (emailInput) {
        const email = emailInput.value;
        if (isValidEmail(email)) {
            showSuccessMessage('¡Suscripción exitosa! Te mantendremos informado.');
            emailInput.value = '';
        } else {
            showErrorMessage('Por favor ingresa un email válido.');
        }
    }
}

// Notes functionality helpers
function autoSaveNote() {
    const noteTextarea = document.getElementById('notes');
    if (noteTextarea) {
        noteTextarea.addEventListener('input', function() {
            // Save to localStorage as backup
            localStorage.setItem('portfolio_note_draft', this.value);
        });
        
        // Load draft on page load
        const draft = localStorage.getItem('portfolio_note_draft');
        if (draft) {
            noteTextarea.value = draft;
        }
    }
}

// Clear draft when note is saved
document.addEventListener('submit', function(e) {
    if (e.target.querySelector('#notes')) {
        localStorage.removeItem('portfolio_note_draft');
    }
});

// Initialize auto-save for notes
autoSaveNote();

// Utility function to format dates
function formatDate(date) {
    return new Intl.DateTimeFormat('es-AR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }).format(date);
}

// Export functions for use in other scripts
window.portfolioUtils = {
    showSuccessMessage,
    showErrorMessage,
    isValidEmail,
    formatDate
};

console.log('Portfolio JavaScript initialized successfully! 🚀');
