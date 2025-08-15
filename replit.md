# Replit Configuration

## Overview
This is a Flask-based portfolio website for José Luis Astiazu, a data analytics consultant. The application provides an interactive platform showcasing professional bio, publications, portfolio, notes functionality, and data analysis capabilities with CSV file upload and visualization features.

## User Preferences
Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Template Engine**: Jinja2 templates with Bootstrap 5 for responsive design
- **UI Framework**: Bootstrap 5 with dark theme, Font Awesome icons, and custom CSS
- **JavaScript Libraries**: Chart.js for data visualization, vanilla JavaScript for interactions
- **Layout Structure**: Sidebar navigation with main content area using Bootstrap grid system

### Backend Architecture
- **Web Framework**: Flask with modular route organization
- **Application Structure**: 
  - `app.py` - Flask application factory and configuration
  - `main.py` - Application entry point
  - `routes.py` - Route handlers and business logic
- **File Upload**: Werkzeug secure filename handling with 16MB file size limit
- **Session Management**: Flask sessions with configurable secret key
- **Static Content**: Bio data and publications stored as Python constants

### Data Storage Solutions
- **File System**: Local uploads directory for CSV file storage
- **Session Storage**: Flask sessions for temporary data
- **Static Data**: Hardcoded bio information and sample publications in Python constants

### Authentication and Authorization
- **Current State**: No authentication system implemented
- **Session Security**: Basic Flask session management with environment-configurable secret key

### File Processing Capabilities
- **CSV Analysis**: Pandas integration for data processing and analysis
- **File Validation**: Restricted to CSV files only with size limitations
- **Data Visualization**: Chart.js integration for interactive charts and graphs

## External Dependencies

### Python Packages
- **Flask**: Web framework for application structure
- **pandas**: Data manipulation and analysis for CSV processing
- **Werkzeug**: WSGI utilities and secure file handling

### Frontend Libraries
- **Bootstrap 5**: CSS framework with agent dark theme from cdn.replit.com
- **Font Awesome 6.4.0**: Icon library from cdnjs.cloudflare.com
- **Chart.js**: JavaScript charting library from cdn.jsdelivr.net

### Development Dependencies
- **ProxyFix**: Werkzeug middleware for handling proxy headers
- **Python logging**: Built-in logging configuration for debugging

### Infrastructure Requirements
- **File System**: Local directory structure for uploads and static assets
- **Environment Variables**: SESSION_SECRET for production security
- **Port Configuration**: Default Flask development server on port 5000