/**
 * Main JavaScript file (Alpine.js components)
 */

// Carousel component
function carousel() {
    return {
        init() {
            if (typeof Splide !== 'undefined') {
                new Splide('.splide', {
                    type: 'loop',
                    autoplay: true,
                    interval: 5000,
                    pauseOnHover: true,
                    arrows: true,
                    pagination: true,
                }).mount();
            }
        }
    };
}

// Newsletter form (example AJAX pattern)
document.addEventListener('alpine:init', () => {
    Alpine.data('newsletter', () => ({
        email: '',
        submitting: false,
        message: '',

        async submit() {
            this.submitting = true;
            try {
                const response = await fetch('/api/newsletter', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRFToken': document.querySelector('meta[name=csrf-token]').content,
                    },
                    body: JSON.stringify({ email: this.email }),
                });
                const data = await response.json();
                this.message = data.message || 'Subscribed!';
                this.email = '';
            } catch (err) {
                this.message = 'Something went wrong.';
            }
            this.submitting = false;
        }
    }));
});
