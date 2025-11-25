
## Custom Branding & Theme Instructions ##

This theme uses a comprehensive styling system based on the **Parsons Corporation color palette**, featuring:
- **Primary Green**: #169309 (Parsons brand green)
- **Clean, professional design** with white backgrounds and dark text
- **Comprehensive styling** covering all major Guacamole interface elements
- **CSS variables** for easy customization

### Quick Start

1. Install the Java JDK: `sudo apt update && sudo apt -y install default-jdk`
2. Add your custom logos to the `images/` directory (must be .png files):
   - `logo.png` - Main logo for login dialog (recommended: 200x200px or larger)
   - `logo-64.png` - Favicon (64x64px)
   - `logo-144.png` - Large icon (144x144px)
3. Customize `custom-theme.css`, `guac-manifest.json`, `translations/en.json`, and `META-INF/MANIFEST.MF` as desired
4. Build and deploy the theme:
```bash
# Run within the custom-theme-builder directory 
jar cfmv branding.jar META-INF/MANIFEST.MF guac-manifest.json css images translations META-INF
sudo mv branding.jar /etc/guacamole/extensions 
sudo chmod 664 /etc/guacamole/extensions/branding.jar 
TOMCAT=$(ls /etc/ | grep tomcat)
sudo systemctl restart guacd && sudo systemctl restart ${TOMCAT}
```

### Theme Customization

#### CSS Variables (Easy Color Customization)

The theme uses CSS variables at the top of `custom-theme.css` for easy customization:

```css
:root {
    --parsons-green: #169309;        /* Primary brand color */
    --parsons-green-hover: #1aad0b;  /* Hover state */
    --bg-primary: #ffffff;            /* Main background */
    --bg-secondary: #f5f5f5;         /* Secondary background */
    --text-primary: #000000;          /* Main text color */
    --text-secondary: #333333;        /* Secondary text */
    --border-color: #e0e0e0;          /* Border color */
    --error-color: #cf2e2e;           /* Error/warning red */
    /* ... and more */
}
```

Simply modify these variables to change colors throughout the entire theme!

#### File Structure Requirements

**DO NOT** change directory structure or file names. File contents can be edited:

- **`META-INF/MANIFEST.MF`**: All values can be updated, but `Name: branding` must match the `.jar` filename
- **`guac-manifest.json`**: 
  - The `"name"` value can be changed to anything
  - The `"namespace"` value (`info.tog.custom-theme`) **MUST** match the namespace in the CSS image path:
    ```css
    .login-ui .login-dialog .logo {
        background-image: url('app/ext/info/tog/custom-theme/images/logo.png');
    }
    ```
- **`css/custom-theme.css`**: Fully customizable - includes comprehensive styling for:
  - Login screen
  - Connection lists
  - Settings pages
  - Menus and dropdowns
  - Forms and inputs
  - Buttons
  - Notifications
  - Modals
  - And much more!

#### Logo Sizing Tips

- **`logo.png`**: Main logo displayed in login dialog (recommended: 200x200px or larger)
- **`logo-64.png`**: Browser favicon (must be 64x64px or smaller)
- **`logo-144.png`**: Large icon for app displays (144x144px)

Adjust the `.login-ui .login-dialog .logo` CSS values to scale your logo:
```css
.login-ui .login-dialog .logo {
    width: 7em;    /* Adjust as needed */
    height: 7em;   /* Adjust as needed */
}
```

To make the login dialog larger, modify:
```css
.login-ui .login-dialog {
    max-width: 500px;  /* Increase as needed */
    padding: 2em;      /* Adjust padding */
}
```

### Debugging Tips

1. **Browser Developer Tools**: Use F12 to inspect elements and test CSS changes in real-time
2. **Clear Browser Cache**: If changes don't appear, clear your browser cache (Ctrl+Shift+Delete)
3. **Check Logs**: Review `/var/log/tomcat*/catalina.out` for extension loading errors
4. **Test Incrementally**: Make small changes and rebuild to identify issues quickly

### Theme Features

This comprehensive theme includes styling for:

✅ Login screen with custom branding  
✅ Connection lists with hover effects  
✅ Settings pages and tabs  
✅ Forms and input fields  
✅ Buttons (primary, secondary, danger)  
✅ Menus and dropdowns  
✅ Notifications (success, error, warning)  
✅ Modals and dialogs  
✅ File system browser  
✅ Responsive design  
✅ Custom scrollbars  
✅ Loading states  
✅ Print styles  

### Reference Documentation

- [Guacamole Extension Documentation](https://guacamole.apache.org/doc/gug/guacamole-ext.html)
- [Guacamole Extension Format](https://guacamole.apache.org/doc/gug/guacamole-ext.html#extension-format)
