import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.widgets import Button
import tkinter as tk
import re
import sys
import subprocess
import argparse
import numpy as np
from collections import defaultdict

class ZoomHandler:
    """Handles zoom and pan functionality for the Gantt chart with dynamic time grid"""
    
    def __init__(self, fig, ax_gantt, ax_resource, time_grid, min_start_time, max_end_time, generator, resource_bars):
        self.fig = fig
        self.ax_gantt = ax_gantt
        self.ax_resource = ax_resource
        self.time_grid = time_grid
        self.generator = generator  # Reference to generator for time grid calculation
        self.original_xlims = (min_start_time, max_end_time)
        self.original_ylims_gantt = ax_gantt.get_ylim()
        self.original_ylims_resource = ax_resource.get_ylim()
        self.min_start_time = min_start_time
        self.max_end_time = max_end_time
        self.original_duration = max_end_time - min_start_time
        self.resource_bars = resource_bars  # Store resource bars for width management
        self.original_bar_width = 1.0  # Original bar width
        self.text_elements = []  #  #xd
        self.base_font_sizes = {}  #  #xd
        
        # Zoom state
        self.zoom_factor = 1.0
        self.is_panning = False
        self.pan_start = None
        
        # Connect events
        self.setup_zoom_controls()
        self.connect_events()

    #xd
    def update_text_sizes_for_zoom(self):
        
        current_xlim = self.ax_gantt.get_xlim()
        current_duration = current_xlim[1] - current_xlim[0]
        zoom_factor = self.original_duration / current_duration
        
        # 
        for text_obj, original_size in self.text_elements:
            # 
            # new_size = original_size * zoom_factor
            text_scale_factor = 1 + (zoom_factor - 1) / 5
            new_size = original_size * text_scale_factor
            # 
            new_size = max(6, min(36, new_size))
            
            # 
            text_obj.set_fontsize(new_size)
        
        print(f"Text zoom: {zoom_factor:.1f}x → {len(self.text_elements)} labels resized")
        
    def update_resource_bar_widths(self):
        """Maintain constant visual width of resource bars during zoom"""
        current_xlim = self.ax_resource.get_xlim()
        current_duration = current_xlim[1] - current_xlim[0]
        zoom_factor = self.original_duration / current_duration
        
        # Calculate new bar width to maintain visual consistency
        # As we zoom in, bars should appear the same visual width
        #new_bar_width = self.original_bar_width / zoom_factor
        new_bar_width = 1.0
        
        # Update all resource bars
        for bar in self.resource_bars:
            bar.set_width(new_bar_width)
        
        print(f"Resource bar widths updated: {new_bar_width:.3f} (zoom: {zoom_factor:.1f}x)")
    
    def update_time_grid_for_zoom(self):
        """Dynamically update time grid based on current zoom level"""
        current_xlim = self.ax_gantt.get_xlim()
        current_start = max(self.min_start_time, current_xlim[0])
        current_end = min(self.max_end_time, current_xlim[1])
        current_duration = current_end - current_start
        
        # Calculate zoom factor based on original vs current view
        original_duration = self.max_end_time - self.min_start_time
        zoom_factor = original_duration / current_duration
        
        print(f"Updating time grid: duration={current_duration:.1f}, zoom_factor={zoom_factor:.2f}")
        
        # Calculate more detailed time grid for zoomed view
        # The more we zoom in, the finer the time intervals
        if zoom_factor > 20:  # Very zoomed in
            time_step = 0.1
        elif zoom_factor > 10:  # Highly zoomed in
            time_step = 0.5
        elif zoom_factor > 5:   # Moderately zoomed in
            time_step = 1
        elif zoom_factor > 2:   # Slightly zoomed in
            time_step = 2
        else:  # Normal or zoomed out view
            # Use original progressive system but adapted to current view
            if current_duration <= 25:
                time_step = 1
            elif current_duration <= 50:
                time_step = 2
            elif current_duration <= 100:
                time_step = 5
            else:
                time_step = max(1, int(current_duration / 20))
        
        # Generate new time grid for current view
        new_time_grid = self.generator.calculate_optimal_time_grid(
            current_duration, self.fig.get_figwidth(), 
            current_start, current_end, 
            len(self.ax_gantt.get_yticklabels()), 
            force_step=time_step
        )
        
        # Update ticks on both axes
        self.update_axis_ticks(self.ax_gantt, new_time_grid)
        self.update_axis_ticks(self.ax_resource, new_time_grid)
        
        # Update resource bar widths to maintain visual consistency
        self.update_resource_bar_widths()
        
        print(f"New time grid: step={time_step}, major_ticks={len(new_time_grid['major_ticks'])}")
        
    def update_axis_ticks(self, ax, time_grid):
        """Update ticks and grid lines for an axis with extended grid lines and smart labels"""
        # Clear existing grid lines
        for line in ax.lines[:]:
            if hasattr(line, '_grid_line'):
                line.remove()
        
        # Get current view limits
        current_xlim = ax.get_xlim()
        
        # Extend grid range beyond current view for smoother panning
        extended_start = current_xlim[0] - (current_xlim[1] - current_xlim[0]) * 0.5
        extended_end = current_xlim[1] + (current_xlim[1] - current_xlim[0]) * 0.5
        
        # Determine which ticks should have labels based on density
        all_ticks = sorted(list(time_grid['major_ticks']) + list(time_grid['minor_ticks']))
        labeled_ticks = self.determine_labeled_ticks(all_ticks, current_xlim, ax)
        
        # ALWAYS set major ticks with labels - this ensures numbers are always visible
        ax.set_xticks(labeled_ticks)
        
        # Force explicit tick labels to ensure they're shown
        if labeled_ticks:
            tick_labels = [str(int(tick)) if tick == int(tick) else f"{tick:.1f}" for tick in labeled_ticks]
            ax.set_xticklabels(tick_labels)
        
        # Add unlabeled minor ticks if they exist and aren't too dense
        unlabeled_ticks = [t for t in all_ticks if t not in labeled_ticks and current_xlim[0] <= t <= current_xlim[1]]
        if len(unlabeled_ticks) < 100:  # Avoid too many minor ticks
            ax.set_xticks(unlabeled_ticks, minor=True)
            ax.tick_params(axis='x', which='minor', length=3, color='gray')
        
        # Ensure major tick parameters are set correctly
        ax.tick_params(axis='x', which='major', length=6, labelsize=8)
        
        # Add new grid lines (extended beyond view)
        for tick in time_grid['major_ticks']:
            if extended_start <= tick <= extended_end:
                line = ax.axvline(x=tick, color='gray', alpha=0.8, linewidth=1.2, zorder=0)
                line._grid_line = True  # Mark as grid line for removal
        
        for tick in time_grid['minor_ticks']:
            if extended_start <= tick <= extended_end:
                line = ax.axvline(x=tick, color='lightgray', alpha=0.5, linewidth=0.6, zorder=0)
                line._grid_line = True  # Mark as grid line for removal
        
        # Add additional grid lines for extended range
        step = time_grid['major_step']
        
        # Add lines before current range
        tick = time_grid['major_ticks'][0] - step if len(time_grid['major_ticks']) > 0 else extended_start
        while tick >= extended_start:
            line = ax.axvline(x=tick, color='gray', alpha=0.8, linewidth=1.2, zorder=0)
            line._grid_line = True
            tick -= step
            
        # Add lines after current range  
        tick = time_grid['major_ticks'][-1] + step if len(time_grid['major_ticks']) > 0 else extended_end
        while tick <= extended_end:
            line = ax.axvline(x=tick, color='gray', alpha=0.8, linewidth=1.2, zorder=0)
            line._grid_line = True
            tick += step
    
    def update_axis_labels_only(self, ax, current_xlim):
        """Quick update of axis labels during panning without full grid recalculation"""
        # Use a simple approach: show labels at regular intervals within current view
        duration = current_xlim[1] - current_xlim[0]
        
        # Calculate appropriate step based on duration
        if duration <= 10:
            step = 1
        elif duration <= 20:
            step = 2
        elif duration <= 50:
            step = 5
        elif duration <= 100:
            step = 10
        else:
            step = max(1, int(duration / 10))
        
        # Generate ticks within current view
        start_tick = int(current_xlim[0] / step) * step
        visible_ticks = []
        tick = start_tick
        while tick <= current_xlim[1]:
            if current_xlim[0] <= tick <= current_xlim[1]:
                visible_ticks.append(tick)
            tick += step
        
        # Limit number of ticks to avoid overcrowding
        if len(visible_ticks) > 15:
            # Take every other tick
            visible_ticks = visible_ticks[::2]
        
        # Set ticks and labels
        if visible_ticks:
            ax.set_xticks(visible_ticks)
            tick_labels = [str(int(tick)) if tick == int(tick) else f"{tick:.1f}" for tick in visible_ticks]
            ax.set_xticklabels(tick_labels)
            ax.tick_params(axis='x', which='major', length=6, labelsize=8)
    
    def determine_labeled_ticks(self, all_ticks, current_xlim, ax):
        """Determine which ticks should have labels to avoid overcrowding"""
        if not all_ticks:
            return []
            
        # Filter ticks within current view
        visible_ticks = [t for t in all_ticks if current_xlim[0] <= t <= current_xlim[1]]
        
        if len(visible_ticks) <= 1:
            return visible_ticks
            
        # Calculate available width per tick
        fig_width_inches = ax.figure.get_figwidth()
        axis_width_fraction = 0.8  # Assume axis takes 80% of figure width
        available_width = fig_width_inches * axis_width_fraction
        
        # Estimate character width in inches (rough approximation)
        char_width_inches = 0.08  # About 0.08 inches per character at normal font size
        
        # Calculate maximum characters per tick label
        max_chars_per_label = 6  # Conservative estimate for numbers like "123.5"
        min_space_between_labels = max_chars_per_label * char_width_inches * 1.5  # 1.5x for spacing
        
        # Calculate how many labels can fit
        total_width = current_xlim[1] - current_xlim[0]
        max_labels = max(1, int(available_width / min_space_between_labels))
        
        print(f"Label determination: {len(visible_ticks)} ticks, max_labels: {max_labels}")
        
        # If we can show all ticks, do it
        if len(visible_ticks) <= max_labels:
            return visible_ticks
        
        # Otherwise, select a subset with regular spacing
        if max_labels == 1:
            # Show only middle tick
            return [visible_ticks[len(visible_ticks)//2]]
        
        # Calculate step to get approximately max_labels
        step = max(1, len(visible_ticks) // max_labels)
        selected_ticks = []
        
        # Always include first and last if possible
        selected_ticks.append(visible_ticks[0])
        
        # Add intermediate ticks
        for i in range(step, len(visible_ticks) - 1, step):
            selected_ticks.append(visible_ticks[i])
        
        # Always include last if it's different from first
        if len(visible_ticks) > 1 and visible_ticks[-1] != visible_ticks[0]:
            selected_ticks.append(visible_ticks[-1])
        
        # Remove duplicates and sort
        selected_ticks = sorted(list(set(selected_ticks)))
        
        print(f"Selected {len(selected_ticks)} labeled ticks from {len(visible_ticks)} total")
        return selected_ticks
        
    def setup_zoom_controls(self):
        """Setup zoom control buttons"""
        try:
            # Create space for buttons at the bottom
            self.fig.subplots_adjust(bottom=0.15)
            
            # Button positions
            button_width = 0.08
            button_height = 0.04
            button_y = 0.02
            spacing = 0.02
            
            # Calculate button positions
            total_width = 6 * button_width + 5 * spacing
            start_x = (1 - total_width) / 2
            
            # Zoom In button
            ax_zoom_in = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_zoom_in = Button(ax_zoom_in, 'Zoom In')
            self.btn_zoom_in.on_clicked(self.zoom_in)
            
            # Zoom Out button
            start_x += button_width + spacing
            ax_zoom_out = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_zoom_out = Button(ax_zoom_out, 'Zoom Out')
            self.btn_zoom_out.on_clicked(self.zoom_out)
            
            # Zoom Fit button
            start_x += button_width + spacing
            ax_zoom_fit = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_zoom_fit = Button(ax_zoom_fit, 'Fit All')
            self.btn_zoom_fit.on_clicked(self.zoom_fit)
            
            # Zoom Time button
            start_x += button_width + spacing
            ax_zoom_time = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_zoom_time = Button(ax_zoom_time, 'Fit Time')
            self.btn_zoom_time.on_clicked(self.zoom_fit_time)
            
            # Zoom Tasks button
            start_x += button_width + spacing
            ax_zoom_tasks = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_zoom_tasks = Button(ax_zoom_tasks, 'Fit Tasks')
            self.btn_zoom_tasks.on_clicked(self.zoom_fit_tasks)
            
            # Reset button
            start_x += button_width + spacing
            ax_reset = plt.axes([start_x, button_y, button_width, button_height])
            self.btn_reset = Button(ax_reset, 'Reset')
            self.btn_reset.on_clicked(self.reset_zoom)
            
            print("Zoom controls added: Zoom In/Out, Fit All, Fit Time, Fit Tasks, Reset")
            
        except Exception as e:
            print("Could not create zoom controls: {}".format(e))
            
    def connect_events(self):
        """Connect mouse events for zoom and pan"""
        try:
            # Mouse wheel zoom
            self.fig.canvas.mpl_connect('scroll_event', self.on_scroll)
            
            # Mouse drag for pan
            self.fig.canvas.mpl_connect('button_press_event', self.on_press)
            self.fig.canvas.mpl_connect('button_release_event', self.on_release)
            self.fig.canvas.mpl_connect('motion_notify_event', self.on_motion)
            
            # Key shortcuts
            self.fig.canvas.mpl_connect('key_press_event', self.on_key_press)
            
            print("Zoom events connected: Mouse wheel, Drag pan, Keyboard shortcuts")
            
        except Exception as e:
            print("Could not connect zoom events: {}".format(e))
    
    def on_scroll(self, event):
        """Handle mouse wheel zoom with dynamic time grid update"""
        if event.inaxes not in [self.ax_gantt, self.ax_resource]:
            return
            
        # Determine zoom factor
        zoom_intensity = 0.1
        if event.button == 'up':
            scale_factor = 1 + zoom_intensity
        elif event.button == 'down':
            scale_factor = 1 - zoom_intensity
        else:
            return
        
        # Get current axis limits
        if event.inaxes == self.ax_gantt:
            ax = self.ax_gantt
        else:
            ax = self.ax_resource
            
        xlim = ax.get_xlim()
        ylim = ax.get_ylim()
        
        # Calculate zoom center (mouse position)
        if event.xdata is not None and event.ydata is not None:
            x_center = event.xdata
            y_center = event.ydata
        else:
            x_center = (xlim[0] + xlim[1]) / 2
            y_center = (ylim[0] + ylim[1]) / 2
        
        # Calculate new X limits (time axis - always zoom)
        x_range = (xlim[1] - xlim[0]) * scale_factor
        new_xlim = [x_center - x_range/2, x_center + x_range/2]
        
        # Apply X zoom to both axes (synchronized time)
        self.ax_gantt.set_xlim(new_xlim)
        self.ax_resource.set_xlim(new_xlim)
        
        # Y zoom behavior depends on which chart is being scrolled
        if event.inaxes == self.ax_gantt:
            # Gantt chart: allow Y zoom as normal
            y_range = (ylim[1] - ylim[0]) * scale_factor
            new_ylim = [y_center - y_range/2, y_center + y_range/2]
            self.ax_gantt.set_ylim(new_ylim)
        else:
            # Resource chart: NEVER zoom Y axis - keep original Y limits
            self.ax_resource.set_ylim(self.original_ylims_resource)
            print("Resource chart Y-axis kept at original limits (no column height zoom)")
        
        # Update time grid for new zoom level
        self.update_time_grid_for_zoom()

        self.update_text_sizes_for_zoom() #xd
        
        self.fig.canvas.draw_idle()
    
    def on_press(self, event):
        """Handle mouse press for pan start"""
        if event.inaxes not in [self.ax_gantt, self.ax_resource]:
            return
            
        if event.button == 1:  # Left click
            self.is_panning = True
            self.pan_start = (event.xdata, event.ydata)
            self.fig.canvas.set_cursor(1)  # Hand cursor
    
    def on_release(self, event):
        """Handle mouse release for pan end"""
        if self.is_panning:
            self.is_panning = False
            self.pan_start = None
            self.fig.canvas.set_cursor(0)  # Default cursor
            # Update time grid after panning
            self.update_time_grid_for_zoom()
            self.update_text_sizes_for_zoom() #xd
            # Force refresh of both axes
            self.fig.canvas.draw_idle()
    
    def on_motion(self, event):
        """Handle mouse motion for panning"""
        if not self.is_panning or self.pan_start is None:
            return
            
        if event.inaxes not in [self.ax_gantt, self.ax_resource] or event.xdata is None or event.ydata is None:
            return
        
        # Calculate pan distance
        dx = self.pan_start[0] - event.xdata
        dy = self.pan_start[1] - event.ydata
        
        # Apply pan to both axes (synchronized X)
        gantt_xlim = self.ax_gantt.get_xlim()
        gantt_ylim = self.ax_gantt.get_ylim()
        resource_xlim = self.ax_resource.get_xlim()
        
        # Pan X synchronized for both charts
        new_gantt_xlim = [gantt_xlim[0] + dx, gantt_xlim[1] + dx]
        new_resource_xlim = [resource_xlim[0] + dx, resource_xlim[1] + dx]
        
        self.ax_gantt.set_xlim(new_gantt_xlim)
        self.ax_resource.set_xlim(new_resource_xlim)
        
        # Pan Y behavior depends on which chart is being panned
        if event.inaxes == self.ax_gantt:
            # Gantt chart: allow Y pan as normal
            new_gantt_ylim = [gantt_ylim[0] + dy, gantt_ylim[1] + dy]
            self.ax_gantt.set_ylim(new_gantt_ylim)
        else:
            # Resource chart: NEVER pan Y axis - keep original Y limits
            self.ax_resource.set_ylim(self.original_ylims_resource)
        
        # Update labels during motion for immediate feedback
        current_gantt_xlim = self.ax_gantt.get_xlim()
        current_resource_xlim = self.ax_resource.get_xlim()
        
        # Quick label update without full grid recalculation
        self.update_axis_labels_only(self.ax_gantt, current_gantt_xlim)
        self.update_axis_labels_only(self.ax_resource, current_resource_xlim)
        
        self.fig.canvas.draw_idle()
    
    def on_key_press(self, event):
        """Handle keyboard shortcuts"""
        if event.key == 'r':
            self.reset_zoom(None)
        elif event.key == '+' or event.key == '=':
            self.zoom_in(None)
        elif event.key == '-':
            self.zoom_out(None)
        elif event.key == 'f':
            self.zoom_fit(None)
        elif event.key == 't':
            self.zoom_fit_time(None)
        elif event.key == 'g':
            self.zoom_fit_tasks(None)
    
    def zoom_in(self, event):
        """Zoom in around center with time grid update"""
        self.zoom_around_center(0.8)
        self.update_time_grid_for_zoom()
        self.update_text_sizes_for_zoom()
    
    def zoom_out(self, event):
        """Zoom out around center with time grid update"""
        self.zoom_around_center(1.25)
        self.update_time_grid_for_zoom()
        self.update_text_sizes_for_zoom()
    
    def zoom_around_center(self, factor):
        """Zoom around the center of current view"""
        # Gantt chart - normal zoom behavior
        gantt_xlim = self.ax_gantt.get_xlim()
        gantt_ylim = self.ax_gantt.get_ylim()
        
        gantt_x_center = (gantt_xlim[0] + gantt_xlim[1]) / 2
        gantt_y_center = (gantt_ylim[0] + gantt_ylim[1]) / 2
        
        gantt_x_range = (gantt_xlim[1] - gantt_xlim[0]) * factor
        gantt_y_range = (gantt_ylim[1] - gantt_ylim[0]) * factor
        
        new_gantt_xlim = [gantt_x_center - gantt_x_range/2, gantt_x_center + gantt_x_range/2]
        new_gantt_ylim = [gantt_y_center - gantt_y_range/2, gantt_y_center + gantt_y_range/2]
        
        # Resource chart - only X zoom, Y stays fixed
        resource_xlim = self.ax_resource.get_xlim()
        resource_x_center = (resource_xlim[0] + resource_xlim[1]) / 2
        resource_x_range = (resource_xlim[1] - resource_xlim[0]) * factor
        new_resource_xlim = [resource_x_center - resource_x_range/2, resource_x_center + resource_x_range/2]
        
        # Apply zoom
        self.ax_gantt.set_xlim(new_gantt_xlim)
        self.ax_gantt.set_ylim(new_gantt_ylim)
        self.ax_resource.set_xlim(new_resource_xlim)
        # Resource Y axis always stays at original limits
        self.ax_resource.set_ylim(self.original_ylims_resource)
        
        print("Resource chart Y-axis kept at original limits during button zoom")
        
        self.fig.canvas.draw_idle()
    
    def zoom_fit(self, event):
        """Fit all content in view"""
        self.reset_zoom(event)
        self.update_text_sizes_for_zoom()
    
    def zoom_fit_time(self, event):
        """Fit time range while keeping current Y zoom with time grid update"""
        self.ax_gantt.set_xlim(self.original_xlims)
        self.ax_resource.set_xlim(self.original_xlims)
        # Keep resource Y axis at original limits
        self.ax_resource.set_ylim(self.original_ylims_resource)
        self.update_time_grid_for_zoom()
        self.update_text_sizes_for_zoom()
        print("Resource chart Y-axis kept at original limits during fit time")
        self.fig.canvas.draw_idle()
    
    def zoom_fit_tasks(self, event):
        """Fit task range while keeping current X zoom"""
        self.ax_gantt.set_ylim(self.original_ylims_gantt)
        self.fig.canvas.draw_idle()
    
    def reset_zoom(self, event):
        """Reset to original view with original time grid"""
        self.ax_gantt.set_xlim(self.original_xlims)
        self.ax_gantt.set_ylim(self.original_ylims_gantt)
        self.ax_resource.set_xlim(self.original_xlims)
        self.ax_resource.set_ylim(self.original_ylims_resource)
        self.zoom_factor = 1.0
        
        # Restore original resource bar widths
        for bar in self.resource_bars:
            bar.set_width(self.original_bar_width)
        
        # Restore original time grid
        self.update_axis_ticks(self.ax_gantt, self.time_grid)
        self.update_axis_ticks(self.ax_resource, self.time_grid)

        self.update_text_sizes_for_zoom() #xd
        
        self.fig.canvas.draw_idle()


class AdaptiveGanttChartGenerator:
    """
    Adaptive Gantt Chart Generator with intelligent scaling and zoom functionality.
    
    Features:
    - Progressive time intervals: 1-50=every 1, 50-100=every 2, 100-150=every 3, etc.
    - Dynamic time grid that adapts during zoom
    - Smart time label visibility to avoid overcrowding
    - Extended grid lines for smooth panning
    - Adaptive dimensions based on content and screen size
    - Interactive zoom with mouse wheel, pan, and keyboard shortcuts
    - Smart font and spacing scaling for optimal readability
    - Fixed resource bar width during zoom
    - Resource chart: zoom affects only time axis (X), height (Y) stays fixed
    """
    def __init__(self):
        # Distinctive colors for each task type
        self.base_colors = [
            "#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA726", "#AB47BC", 
            "#66BB6A", "#FF8A65", "#42A5F5", "#FFCA28", "#8D6E63",
            "#A1887F", "#90A4AE", "#F06292", "#7986CB", "#FFB74D",
            "#E57373", "#81C784", "#64B5F6", "#FFD54F", "#F06292"
        ]
        self.task_colors = {}
        self.color_index = 0
        self.screen_info = self._get_screen_info()
        
    def _get_screen_info(self):
        """Get screen dimensions and DPI for adaptive sizing"""
        try:
            root = tk.Tk()
            screen_width = root.winfo_screenwidth()
            screen_height = root.winfo_screenheight()
            
            # Try to get DPI (fallback to 96 if not available)
            try:
                dpi = root.winfo_fpixels('1i')
            except:
                dpi = 96
                
            root.destroy()
            
            return {
                'width': screen_width,
                'height': screen_height,
                'dpi': dpi,
                'width_inches': screen_width / dpi,
                'height_inches': screen_height / dpi
            }
        except:
            # Fallback values if tkinter is not available
            return {
                'width': 1920,
                'height': 1080, 
                'dpi': 96,
                'width_inches': 20,
                'height_inches': 11.25
            }
    
    def get_color_for_task_type(self, task_type):
        """Assigns a unique color for each task type"""
        if task_type not in self.task_colors:
            self.task_colors[task_type] = self.base_colors[self.color_index % len(self.base_colors)]
            self.color_index += 1
        return self.task_colors[task_type]
    
    def calculate_adaptive_dimensions(self, tasks, task_lines, chart_duration, display_mode='auto'):
        """Calculate optimal figure dimensions based on content and screen size"""
        
        # Content-based calculations
        num_lines = len(task_lines)
        max_task_name_length = max(len(line['type']) for line in task_lines) if task_lines else 10
        
        # Adaptive scaling based on number of lines
        if num_lines <= 5:
            line_height_factor = 0.8
            time_width_factor = 0.4
        elif num_lines <= 10:
            line_height_factor = 0.7
            time_width_factor = 0.5  # Wider for better time readability
        elif num_lines <= 15:
            line_height_factor = 0.6
            time_width_factor = 0.6
        elif num_lines <= 25:
            line_height_factor = 0.5
            time_width_factor = 0.7
        else:
            line_height_factor = 0.4
            time_width_factor = 0.8  # Much wider for complex charts
        
        # Base dimensions (content-driven with adaptive factors)
        base_width = max(12, chart_duration * time_width_factor + max_task_name_length * 0.3)
        base_height = max(8, num_lines * line_height_factor + 5)  # Gantt + resource chart space
        
        print("Adaptive scaling: {} lines -> line_factor={:.1f}, width_factor={:.1f}".format(
            num_lines, line_height_factor, time_width_factor))
        
        # Screen constraints
        screen_info = self.screen_info
        max_usable_width = screen_info['width_inches'] * 0.9  # 90% of screen width
        max_usable_height = screen_info['height_inches'] * 0.8  # 80% of screen height
        
        if display_mode == 'fullscreen':
            # Use maximum available space
            fig_width = min(max_usable_width, base_width * 1.5)
            fig_height = min(max_usable_height, base_height * 1.3)
        elif display_mode == 'compact':
            # Minimize space usage but ensure readability with many lines
            compact_factor = max(0.6, 1.0 - (num_lines / 50))  # Don't go too compact with many lines
            fig_width = min(max_usable_width * 0.7, base_width * compact_factor)
            fig_height = min(max_usable_height * 0.7, base_height * compact_factor)
        else:  # auto mode
            # Smart scaling based on content density
            content_density = (num_lines * chart_duration) / 100
            
            if content_density > 100:  # Very high density - use much more space
                scale_factor = 1.5
            elif content_density > 50:  # High density - use more space
                scale_factor = 1.2
            elif content_density < 10:  # Low density - use less space
                scale_factor = 0.8
            else:  # Medium density
                scale_factor = 1.0
                
            # Additional scaling for line count
            if num_lines > 20:
                scale_factor *= 1.3  # Extra space for many lines
            elif num_lines > 15:
                scale_factor *= 1.1
                
            fig_width = min(max_usable_width, base_width * scale_factor)
            fig_height = min(max_usable_height, base_height * scale_factor)
        
        return fig_width, fig_height
    
    def calculate_adaptive_font_sizes(self, fig_width, fig_height, num_lines, chart_duration):
        """Calculate optimal font sizes based on figure dimensions and content density"""
        
        # Base font sizes
        base_title_size = 14
        base_label_size = 12
        base_tick_size = 10
        base_task_size = 9
        
        # Scale factors based on figure size
        width_scale = min(1.5, fig_width / 12)  # Reference width: 12 inches
        height_scale = min(1.5, fig_height / 8)  # Reference height: 8 inches
        
        # Line density adjustments - reduce font size with many lines
        if num_lines <= 5:
            line_density_factor = 1.0
        elif num_lines <= 10:
            line_density_factor = 0.9
        elif num_lines <= 15:
            line_density_factor = 0.8
        elif num_lines <= 25:
            line_density_factor = 0.7
        else:
            line_density_factor = 0.6
        
        # Time density adjustments
        time_density = chart_duration / fig_width
        if time_density > 10:  # Too many time units per inch
            time_density_factor = 0.8
        elif time_density > 5:
            time_density_factor = 0.9
        else:
            time_density_factor = 1.0
            
        scale_factor = min(width_scale, height_scale) * line_density_factor * time_density_factor
        
        print("Font scaling: width={:.1f}, height={:.1f}, lines={:.1f}, time={:.1f} -> {:.2f}".format(
            width_scale, height_scale, line_density_factor, time_density_factor, scale_factor))
        
        return {
            'title': max(8, int(base_title_size * scale_factor)),
            'label': max(8, int(base_label_size * scale_factor)),
            'tick': max(7, int(base_tick_size * scale_factor)),
            'task': max(6, int(base_task_size * scale_factor))
        }
    
    def calculate_adaptive_spacing(self, fig_height, num_lines):
        """Calculate optimal spacing between elements based on line count"""
        
        available_height = fig_height * 0.7  # 70% for Gantt chart
        
        if num_lines > 0:
            # Adaptive line height based on number of lines
            if num_lines <= 5:
                base_line_height = 0.8
                line_spacing_factor = 0.15
            elif num_lines <= 10:
                base_line_height = 0.7
                line_spacing_factor = 0.12
            elif num_lines <= 15:
                base_line_height = 0.6
                line_spacing_factor = 0.10
            elif num_lines <= 25:
                base_line_height = 0.5
                line_spacing_factor = 0.08
            else:
                base_line_height = 0.4
                line_spacing_factor = 0.05
                
            # Calculate actual line height, ensuring minimum readability
            calculated_line_height = available_height / num_lines
            line_height = min(base_line_height, max(0.3, calculated_line_height * 0.9))
            line_spacing = line_height * line_spacing_factor
            
            print("Spacing adaptation: {} lines -> height={:.2f}, spacing={:.2f}".format(
                num_lines, line_height, line_spacing))
        else:
            line_height = 0.8
            line_spacing = 0.08
            
        return {
            'line_height': line_height,
            'line_spacing': line_spacing,
            'margin': 0.05 * fig_height,
            'num_lines': num_lines
        }
    
    def calculate_optimal_time_grid(self, chart_duration, fig_width, min_start_time, max_end_time, num_lines, force_step=None):
        """Calculate intervals that LAND on integer values"""
        
        # Calcola step normale (mantieni la logica progressiva)
        if force_step:
            best_step = max(1, int(force_step))
        else:
            if chart_duration <= 50:
                best_step = 1
            elif chart_duration <= 100:
                best_step = 2
            elif chart_duration <= 150:
                best_step = 3
            elif chart_duration <= 200:
                best_step = 4
            elif chart_duration <= 250:
                best_step = 5
            elif chart_duration <= 300:
                best_step = 6
            elif chart_duration <= 400:
                best_step = 8
            elif chart_duration <= 500:
                best_step = 10
            elif chart_duration <= 750:
                best_step = 15
            elif chart_duration <= 1000:
                best_step = 20
            elif chart_duration <= 1500:
                best_step = 30
            elif chart_duration <= 2000:
                best_step = 40
            else:
                best_step = max(50, int(chart_duration // 40))
        
        print("Integer-landing intervals: duration={} -> step={}".format(chart_duration, best_step))
        
        # NUOVA PARTE: Calcola primo tick che cade su un intero
        first_integer = int(min_start_time)
        if first_integer < min_start_time:
            first_integer += 1  # Vai al prossimo intero
        
        # Trova il primo multiplo di best_step che è >= first_integer
        if best_step == 1:
            start_tick = first_integer
        else:
            start_tick = ((first_integer + best_step - 1) // best_step) * best_step
        
        # Genera major ticks (tutti interi!)
        major_ticks = []
        current_tick = start_tick
        while current_tick <= max_end_time:
            major_ticks.append(current_tick)
            current_tick += best_step
        
        # Minor ticks (anche interi!)
        minor_step = max(1, best_step // 2) if best_step > 1 else 1
        minor_ticks = []
        
        if minor_step < best_step:
            first_minor = ((first_integer + minor_step - 1) // minor_step) * minor_step
            current_minor = first_minor
            while current_minor <= max_end_time:
                if current_minor not in major_ticks:
                    minor_ticks.append(current_minor)
                current_minor += minor_step
        
        major_ticks = np.array(major_ticks)
        minor_ticks = np.array(minor_ticks)
        
        print(f"Calculated integer intervals: major={list(major_ticks[:5])}..., minor={list(minor_ticks[:5])}...")
        
        return {
            'major_step': best_step,
            'minor_step': minor_step,
            'major_ticks': major_ticks,
            'minor_ticks': minor_ticks,
            'grid_step': minor_step if minor_step < best_step else best_step
        }


    '''
    def calculate_optimal_time_grid(self, chart_duration, fig_width, min_start_time, max_end_time, num_lines, force_step=None):
        """Calculate optimal time grid spacing based on chart duration with progressive intervals"""
        
        if force_step:
            # Use forced step size
            best_step = force_step
            major_ticks = np.arange(min_start_time, max_end_time + best_step, best_step)
            major_ticks = major_ticks[major_ticks <= max_end_time]
            
            # Calculate minor step for forced step
            minor_step = best_step
            if best_step >= 10:
                if best_step % 5 == 0:
                    minor_step = best_step // 5
                elif best_step % 2 == 0:
                    minor_step = best_step // 2
            elif best_step > 1:
                minor_step = 1
                
            minor_ticks = []
            if minor_step < best_step:
                start_minor = (min_start_time // minor_step) * minor_step
                all_minor = np.arange(start_minor, max_end_time + minor_step, minor_step)
                minor_ticks = [t for t in all_minor if t not in major_ticks and min_start_time <= t <= max_end_time]
                
            return {
                'major_step': best_step,
                'minor_step': minor_step,
                'major_ticks': major_ticks,
                'minor_ticks': np.array(minor_ticks),
                'grid_step': minor_step if minor_step < best_step else best_step
            }
        
        # Progressive time interval calculation based on chart duration
        # Up to 50: every 1, 50-100: every 2, 100-150: every 3, 150-200: every 4, etc.
        
        if chart_duration <= 50:
            best_step = 1
        elif chart_duration <= 100:
            best_step = 2
        elif chart_duration <= 150:
            best_step = 3
        elif chart_duration <= 200:
            best_step = 4
        elif chart_duration <= 250:
            best_step = 5
        elif chart_duration <= 300:
            best_step = 6
        elif chart_duration <= 400:
            best_step = 8
        elif chart_duration <= 500:
            best_step = 10
        elif chart_duration <= 750:
            best_step = 15
        elif chart_duration <= 1000:
            best_step = 20
        elif chart_duration <= 1500:
            best_step = 30
        elif chart_duration <= 2000:
            best_step = 40
        else:
            # For very long durations, use a step that gives reasonable tick count
            best_step = max(50, chart_duration // 40)
        
        print("Progressive time grid: duration={} -> step={}".format(chart_duration, best_step))
        
        # Generate major ticks
        start_tick = (min_start_time // best_step) * best_step
        major_ticks = np.arange(start_tick, max_end_time + best_step, best_step)
        major_ticks = major_ticks[(major_ticks >= min_start_time) & (major_ticks <= max_end_time)]
        
        # Generate minor ticks based on major step
        minor_step = best_step
        
        # Add minor ticks for better granularity - more aggressive approach
        if best_step >= 10:
            if best_step % 5 == 0:
                minor_step = best_step // 5
            elif best_step % 2 == 0:
                minor_step = best_step // 2
            else:
                minor_step = best_step // 2 if best_step > 2 else 1
        elif best_step >= 4:
            if best_step % 2 == 0:
                minor_step = best_step // 2
            else:
                minor_step = 1
        elif best_step in [2, 3]:
            minor_step = 1
        else:  # best_step == 1
            minor_step = 1  # No sub-division needed
        
        # Generate minor ticks - be more permissive
        minor_ticks = []
        if minor_step < best_step:
            start_minor = (min_start_time // minor_step) * minor_step
            all_minor = np.arange(start_minor, max_end_time + minor_step, minor_step)
            # Remove major ticks from minor ticks
            minor_ticks = [t for t in all_minor if t not in major_ticks and min_start_time <= t <= max_end_time]
        
        return {
            'major_step': best_step,
            'minor_step': minor_step,
            'major_ticks': major_ticks,
            'minor_ticks': np.array(minor_ticks),
            'grid_step': minor_step if minor_step < best_step else best_step
        }
    '''
    
    def parse_output(self, output_text):
        """Extracts data from the scheduling program output"""
        lines = output_text.strip().split('\n')
        
        tasks = []
        makespan = 0
        resource_data = ""
        
        print("Parsing output...")
        
        # Extract makespan
        for line in lines:
            if line.strip().startswith("Makespan end:"):
                makespan = int(line.split(":")[1].strip())
                print("Makespan found: {}".format(makespan))
                break
        
        # Extract tasks from Schedule section
        in_schedule = False
        task_count = 0
        
        for line in lines:
            original_line = line
            line = line.strip()
            
            if line == "Schedule:":
                in_schedule = True
                print("Starting Schedule section")
                continue
            elif line.startswith("===") or line.startswith("Time:") or line.startswith("Resource:"):
                if in_schedule:
                    print("End Schedule section - Tasks found: {}".format(task_count))
                in_schedule = False
                
            if in_schedule and line:
                # Pattern for tasks with support for parentheses and spaces
                pattern = r'Task\s+"([^"]+)"\s*(\([^)]+\))?\s*:\s*start=(\d+),\s*end=(\d+)'
                match = re.match(pattern, line)
                
                if match:
                    base_name = match.group(1)
                    rep_part = match.group(2) if match.group(2) else ""
                    start_time = int(match.group(3))
                    end_time = int(match.group(4))
                    
                    # Build full name and repetition number
                    if rep_part:
                        full_name = "{} {}".format(base_name, rep_part)
                        # Extract repetition number (Rep2 -> R2, Rep3 -> R3, etc.)
                        rep_match = re.search(r'Rep(\d+)', rep_part)
                        if rep_match:
                            rep_number = "R{}".format(rep_match.group(1))
                        else:
                            rep_number = rep_part.strip("()")
                    else:
                        full_name = base_name
                        rep_number = "1"
                    
                    # Determine base task type
                    task_type = base_name.split()[0] if base_name else "Unknown"
                    
                    task = {
                        "name": full_name,
                        "base_name": base_name,
                        "rep_number": rep_number,
                        "start": start_time,
                        "end": end_time,
                        "type": task_type,
                        "duration": end_time - start_time
                    }
                    
                    tasks.append(task)
                    task_count += 1
                    print("  Task {}: {} ({}-{}) [Rep: {}]".format(task_count, full_name, start_time, end_time, rep_number))
        
        # Extract resource data if present
        for line in lines:
            if line.strip().startswith("Resource:"):
                resource_data = line.split("Resource:")[1].strip()
                print("Resource data found: {}...".format(resource_data[:30]))
                break
        
        print("Total tasks extracted: {}".format(len(tasks)))
        return tasks, makespan, resource_data
    
    def organize_tasks_by_type(self, tasks):
        """Organizes tasks by type, separating concurrent ones on different lines"""
        task_lines = []
        
        # Group by type
        task_groups = defaultdict(list)
        for task in tasks:
            task_groups[task["type"]].append(task)
        
        # For each type, organize tasks in separate lines if concurrent
        for task_type in sorted(task_groups.keys()):
            type_tasks = task_groups[task_type]
            type_tasks.sort(key=lambda x: x["start"])
            
            print("Organizing {}: {} tasks".format(task_type, len(type_tasks)))
            
            # Create lines for this task type
            type_lines = []
            
            for task in type_tasks:
                # Find the first line where this task can be placed
                placed = False
                for line in type_lines:
                    # Check if it can be placed on this line (no overlap)
                    can_place = True
                    for existing_task in line:
                        # Two tasks overlap if one starts before the other ends
                        if not (task["end"] <= existing_task["start"] or task["start"] >= existing_task["end"]):
                            can_place = False
                            break
                    
                    if can_place:
                        line.append(task)
                        placed = True
                        print("  {} -> Existing line {}".format(task['rep_number'], len(type_lines)))
                        break
                
                # If it can't be placed on any existing line, create a new line
                if not placed:
                    type_lines.append([task])
                    print("  {} -> New line {}".format(task['rep_number'], len(type_lines)))
            
            # Add all lines of this type to total lines
            for line in type_lines:
                task_lines.append({
                    'type': task_type,
                    'tasks': line,
                    'line_number': len([l for l in task_lines if l['type'] == task_type]) + 1
                })
        
        return task_lines
    
    def parse_resource_data(self, resource_data, makespan):
        """Converts resource data to numeric array"""
        if not resource_data:
            return np.zeros(makespan + 1)
        
        resource_values = []
        resource_data_clean = resource_data.strip()
        
        print("Parsing resource data: length={}, makespan={}".format(len(resource_data_clean), makespan))
        
        # Handle both formats with and without separators
        if ';' in resource_data_clean:
            # Format with separators: "1;2;1;2;1;2;..."
            resource_parts = resource_data_clean.split(';')
            print("Format with separators detected: {} values".format(len(resource_parts)))
            
            for part in resource_parts:
                try:
                    value = int(part.strip()) if part.strip() else 0
                    resource_values.append(value)
                except ValueError:
                    resource_values.append(0)
                    print("Invalid value: '{}'".format(part))
        else:
            # Format without separators (backward compatibility): "121212121222..."
            print("Format without separators (legacy)")
            for char in resource_data_clean:
                try:
                    value = int(char)
                    resource_values.append(value)
                except ValueError:
                    resource_values.append(0)
                    print("Invalid character: '{}'".format(char))
        
        result = np.array(resource_values)
        min_val = min(result) if len(result) > 0 else 0
        max_val = max(result) if len(result) > 0 else 0
        print("Resource values parsed: {} values, range: {}-{}".format(len(result), min_val, max_val))
        
        return result
    
    def create_gantt_chart(self, tasks, makespan, resource_data="", title="Workload Scheduling Problem", 
                          save_path=None, display_mode='auto', interactive=True, time_step=None, enable_zoom=True):
        """Creates the adaptive Gantt chart with resource consumption and smart time labeling"""
        
        # Initialize zoom handler variable at the very beginning
        zoom_handler = None
        
        if not tasks:
            print("No tasks to visualize!")
            return None, None, None
        
        print("\nCreating adaptive chart for {} tasks...".format(len(tasks)))
        print("Screen info: {}x{} pixels ({:.1f}x{:.1f} inches, {:.0f} DPI)".format(
            self.screen_info['width'], self.screen_info['height'],
            self.screen_info['width_inches'], self.screen_info['height_inches'],
            self.screen_info['dpi']))
        
        # Calculate time range
        min_start_time = min(task["start"] for task in tasks)
        max_end_time = max(task["end"] for task in tasks)
        chart_duration = max_end_time - min_start_time
        
        print("Time range: {} to {} (duration: {})".format(min_start_time, max_end_time, chart_duration))
        
        # Organize tasks by type with concurrent separation
        task_lines = self.organize_tasks_by_type(tasks)
        
        # Calculate adaptive dimensions
        fig_width, fig_height = self.calculate_adaptive_dimensions(tasks, task_lines, chart_duration, display_mode)
        print("Adaptive dimensions: {:.1f}x{:.1f} inches".format(fig_width, fig_height))
        
        # Calculate adaptive font sizes
        font_sizes = self.calculate_adaptive_font_sizes(fig_width, fig_height, len(task_lines), chart_duration)
        print("Font sizes: title={}, label={}, tick={}, task={}".format(
            font_sizes['title'], font_sizes['label'], font_sizes['tick'], font_sizes['task']))
        
        # Calculate adaptive spacing
        spacing = self.calculate_adaptive_spacing(fig_height, len(task_lines))
        
        # Calculate optimal time grid considering number of lines
        time_grid = self.calculate_optimal_time_grid(chart_duration, fig_width, min_start_time, max_end_time, len(task_lines), time_step)
        print("Time grid: major step={}, minor step={}, major ticks={}, minor ticks={} (progressive system for {} duration)".format(
            time_grid['major_step'], time_grid['minor_step'], len(time_grid['major_ticks']), len(time_grid['minor_ticks']), chart_duration))
        
        # Convert resource data
        resource_values = self.parse_resource_data(resource_data, makespan)
        max_resource = max(resource_values) if len(resource_values) > 0 and max(resource_values) > 0 else 0
        
        # Create subplot: Gantt above, resource below
        fig, (ax_gantt, ax_resource) = plt.subplots(2, 1, figsize=(fig_width, fig_height), 
                                                gridspec_kw={'height_ratios': [3, 1]})
        
        # === GANTT CHART ===
        line_height = spacing['line_height']
        
        print("Creating Gantt Chart with {} lines...".format(len(task_lines)))
        
        # Draw tasks
        for line_idx, line_info in enumerate(task_lines):
            y_pos = line_idx
            task_type = line_info['type']
            line_tasks = line_info['tasks']
            line_number = line_info['line_number']
            
            color = self.get_color_for_task_type(task_type)
            
            for task in line_tasks:
                # Task bar with adaptive styling
                border_width = 1.5 if len(task_lines) <= 15 else 1.0  # Thinner borders for many lines
                
                rect = patches.Rectangle(
                    (task["start"], y_pos - line_height/2),
                    task["duration"],
                    line_height,
                    linewidth=border_width,
                    edgecolor='black',
                    facecolor=color,
                    alpha=0.8
                )
                ax_gantt.add_patch(rect)
                
                
                # Adaptive text size and visibility based on bar size and line count
                min_duration_for_text = 1 if len(task_lines) <= 10 else 2
                if task["duration"] >= min_duration_for_text:
                    # Calculate text size based on available space
                    base_text_size = font_sizes['task']
                    if len(task_lines) > 30:
                        base_text_size = max(3, base_text_size - 4)  # Still bigger
                    elif len(task_lines) > 25:
                        base_text_size = max(4, base_text_size - 3)
                    elif len(task_lines) > 20:
                        base_text_size = max(5, base_text_size - 2)
                    elif len(task_lines) > 15:
                        base_text_size = max(6, base_text_size - 1)
                    
                    # Further adjust based on bar width
                    width_adjusted_size = min(base_text_size, max(5, task["duration"] * 2))
                    
                    # Simplify text for small spaces
                    display_text = task["rep_number"]
                    if len(task_lines) > 20 and len(display_text) > 2:
                        # Use just numbers for very crowded charts
                        if display_text.startswith('R'):
                            display_text = display_text[1:]  # Remove 'R' prefix
                    
                    text_color = 'white' if task["duration"] > 3 or len(task_lines) > 15 else 'black'
                    
                    # ax_gantt.text(
                    #     task["start"] + task["duration"]/2,
                    #     y_pos,
                    #     display_text,
                    #     ha='center', va='center',
                    #     fontsize=width_adjusted_size,
                    #     fontweight='bold',
                    #     color=text_color
                    # )
                    #xd
                    text_element = ax_gantt.text(
                        task["start"] + task["duration"]/2,
                        y_pos,
                        display_text,
                        ha='center', va='center',
                        fontsize=width_adjusted_size,
                        fontweight='bold',
                        color=text_color
                    )

                    # Salva per il zoom handler (verrà collegato dopo)
                    if not hasattr(ax_gantt, '_pending_text_elements'):
                        ax_gantt._pending_text_elements = []
                    ax_gantt._pending_text_elements.append((text_element, width_adjusted_size))
                
                '''
                min_duration_for_text = 0.5 if len(task_lines) <= 10 else 1  # Show text on smaller bars
                if task["duration"] >= min_duration_for_text:
                    # BIGGER base font size
                    base_text_size = font_sizes['task'] + 1  # Increase by 6 points
                    
                    # Adjust for line density but keep larger
                    if len(task_lines) > 25:
                        base_text_size = max(6, base_text_size - 3)  # Still bigger
                    elif len(task_lines) > 20:
                        base_text_size = max(7, base_text_size - 2)
                    elif len(task_lines) > 15:
                        base_text_size = max(8, base_text_size - 1)
                    
                    # More generous width-based sizing
                    width_adjusted_size = min(base_text_size, max(8, task["duration"] * 2))
                    
                    # Simplify text for small spaces
                    display_text = task["rep_number"]
                    if len(task_lines) > 20 and len(display_text) > 2:
                        if display_text.startswith('R'):
                            display_text = display_text[1:]  # Remove 'R' prefix only for very crowded charts
                    
                    text_color = 'white' if task["duration"] > 2 or len(task_lines) > 15 else 'black'
                    
                    # Create text element
                    text_elem = ax_gantt.text(
                        task["start"] + task["duration"]/2,
                        y_pos,
                        display_text,
                        ha='center', va='center',
                        fontsize=width_adjusted_size,
                        fontweight='bold',
                        color=text_color
                    )
                    
                    # Store for zoom updates (will be processed after zoom_handler creation)
                    if not hasattr(ax_gantt, '_text_elements'):
                        ax_gantt._text_elements = []
                    ax_gantt._text_elements.append((text_elem, width_adjusted_size))
                '''
        
        # Gantt axes configuration
        ax_gantt.set_xlim(min_start_time, max_end_time)
        ax_gantt.set_ylim(-0.5, len(task_lines) - 0.5)
        
        # Y labels with task names and line number if multiple - adaptive for many lines
        y_labels = []
        y_label_fontsize = font_sizes['tick']
        
        for line_info in task_lines:
            task_type = line_info['type']
            line_number = line_info['line_number']
            
            # Count how many lines this task type has
            type_line_count = len([l for l in task_lines if l['type'] == task_type])
            
            if type_line_count > 1:
                label = "{}_Conc{}".format(task_type, line_number)
            else:
                label = task_type
                
            # Truncate labels if we have many lines to avoid overlap
            if len(task_lines) > 30:
                if len(label) > 27:
                    label = label[:24] + "..."
            elif len(task_lines) > 25:
                if len(label) > 30:
                    label = label[:27] + "..."
                    
            y_labels.append(label)
        
        # Adjust Y label font size for many lines
        if len(task_lines) > 20:
            y_label_fontsize = max(6, y_label_fontsize - 2)
        elif len(task_lines) > 15:
            y_label_fontsize = max(7, y_label_fontsize - 1)
        
        ax_gantt.set_yticks(range(len(task_lines)))
        ax_gantt.set_yticklabels(y_labels, fontsize=y_label_fontsize)
        ax_gantt.invert_yaxis()
        
        # Add intelligent time grid with extended lines
        extended_start = min_start_time - chart_duration * 0.2
        extended_end = max_end_time + chart_duration * 0.2
        
        # Determine which ticks should have labels using smart algorithm
        all_ticks = sorted(list(time_grid['major_ticks']) + list(time_grid['minor_ticks']))
        
        # For initial display, use smart labeling
        def determine_initial_labeled_ticks(all_ticks, xlim, fig_width):
            """Determine initial tick labels based on available space"""
            if not all_ticks:
                return []
                
            # Filter ticks within view
            visible_ticks = [t for t in all_ticks if xlim[0] <= t <= xlim[1]]
            
            if len(visible_ticks) <= 1:
                return visible_ticks
                
            # Estimate available space
            axis_width_fraction = 0.8
            available_width = fig_width * axis_width_fraction
            char_width_inches = 0.08
            max_chars_per_label = 6
            min_space_between_labels = max_chars_per_label * char_width_inches * 1.5
            
            max_labels = max(1, int(available_width / min_space_between_labels))
            
            # If we can show all ticks, do it
            if len(visible_ticks) <= max_labels:
                return visible_ticks
            
            # Otherwise, select subset with regular spacing
            if max_labels == 1:
                return [visible_ticks[len(visible_ticks)//2]]
            
            step = max(1, len(visible_ticks) // max_labels)
            selected_ticks = []
            
            # Always include first and last if possible
            selected_ticks.append(visible_ticks[0])
            
            # Add intermediate ticks
            for i in range(step, len(visible_ticks) - 1, step):
                selected_ticks.append(visible_ticks[i])
            
            # Always include last if different from first
            if len(visible_ticks) > 1 and visible_ticks[-1] != visible_ticks[0]:
                selected_ticks.append(visible_ticks[-1])
            
            return sorted(list(set(selected_ticks)))
        
        # Determine initial labeled ticks
        initial_labeled_ticks = determine_initial_labeled_ticks(all_ticks, (min_start_time, max_end_time), fig_width)
        
        # Set initial ticks with labels
        ax_gantt.set_xticks(initial_labeled_ticks)
        
        # Add unlabeled minor ticks
        unlabeled_ticks = [t for t in all_ticks if t not in initial_labeled_ticks and min_start_time <= t <= max_end_time]
        if len(unlabeled_ticks) < 100:
            ax_gantt.set_xticks(unlabeled_ticks, minor=True)
            ax_gantt.tick_params(axis='x', which='minor', length=3, color='gray')
        
        # Major grid lines (thicker, darker) - extended range
        all_major_ticks = list(time_grid['major_ticks'])
        step = time_grid['major_step']
        
        # Extend backwards
        tick = time_grid['major_ticks'][0] - step if len(time_grid['major_ticks']) > 0 else extended_start
        while tick >= extended_start:
            all_major_ticks.insert(0, tick)
            tick -= step
            
        # Extend forwards
        tick = time_grid['major_ticks'][-1] + step if len(time_grid['major_ticks']) > 0 else extended_end
        while tick <= extended_end:
            all_major_ticks.append(tick)
            tick += step
        
        for tick in all_major_ticks:
            line = ax_gantt.axvline(x=tick, color='gray', alpha=0.8, linewidth=1.2, zorder=0)
            line._grid_line = True  # Mark for zoom handler
        
        # Minor grid lines (thinner, lighter) - extended range
        all_minor_ticks = list(time_grid['minor_ticks'])
        minor_step = time_grid['minor_step']
        
        if minor_step < time_grid['major_step']:
            # Extend minor ticks too
            if len(time_grid['minor_ticks']) > 0:
                tick = time_grid['minor_ticks'][0] - minor_step
                while tick >= extended_start:
                    if tick not in all_major_ticks:
                        all_minor_ticks.insert(0, tick)
                    tick -= minor_step
                    
                tick = time_grid['minor_ticks'][-1] + minor_step
                while tick <= extended_end:
                    if tick not in all_major_ticks:
                        all_minor_ticks.append(tick)
                    tick += minor_step
        
        for tick in all_minor_ticks:
            line = ax_gantt.axvline(x=tick, color='lightgray', alpha=0.5, linewidth=0.6, zorder=0)
            line._grid_line = True  # Mark for zoom handler
        
        # Remove top and right borders
        ax_gantt.spines['top'].set_visible(False)
        ax_gantt.spines['right'].set_visible(False)
        
        # Titles and labels with adaptive font sizes
        ax_gantt.set_title(title, fontsize=font_sizes['title'], fontweight='bold', pad=20)
        ax_gantt.set_xlabel('Time\nResource Utilization', fontsize=font_sizes['label'])
        
        ax_gantt.tick_params(axis='x', which='major', labelsize=font_sizes['tick'], length=6)
        
        # === RESOURCE CONSUMPTION CHART ===
        print("Creating Resource Chart...")
        
        # Prepare resource data
        chart_duration_actual = max_end_time - min_start_time + 1
        if len(resource_values) >= chart_duration_actual:
            relevant_resource_values = resource_values[:chart_duration_actual]
        else:
            padding_needed = chart_duration_actual - len(resource_values)
            relevant_resource_values = np.concatenate([resource_values, np.zeros(padding_needed)])
        
        time_points = np.arange(min_start_time, min_start_time + len(relevant_resource_values))
        
        # Bars for resource consumption - save reference for zoom handler
        bars = ax_resource.bar(time_points, relevant_resource_values, 
                           width=1.0, color='#4A90E2', alpha=0.7, 
                           edgecolor='black', linewidth=0.5, align='edge')
        resource_bars = list(bars)  # Convert to list for zoom handler
        
        # Add values above bars for small charts only
        if chart_duration <= 25 and fig_width > 10:
            for i, value in enumerate(relevant_resource_values):
                if value > 0:
                    ax_resource.text(min_start_time + i, value + 0.1, str(int(value)), 
                                 ha='center', va='bottom', fontsize=font_sizes['tick']-1)
        
        # Resource chart configuration
        ax_resource.set_xlim(min_start_time, max_end_time)
        
        # Calculate Y range intelligently
        relevant_max_resource = max(relevant_resource_values) if len(relevant_resource_values) > 0 else 0
        if relevant_max_resource > 0:
            y_max = max(6, relevant_max_resource + 2)
        else:
            y_max = 7
            
        ax_resource.set_ylim(0, y_max)
        ax_resource.set_xlabel('Time', fontsize=font_sizes['label'])
        ax_resource.set_ylabel('Resource Utilization', fontsize=font_sizes['label'])
        
        # Grid and styling
        ax_resource.grid(True, alpha=0.3, axis='y')
        ax_resource.set_axisbelow(True)
        ax_resource.spines['top'].set_visible(False)
        ax_resource.spines['right'].set_visible(False)
        
        # Synchronize X axes with the same intelligent grid and smart labeling
        ax_resource.set_xticks(initial_labeled_ticks)
        if len(unlabeled_ticks) < 100:
            ax_resource.set_xticks(unlabeled_ticks, minor=True)
            ax_resource.tick_params(axis='x', which='minor', length=3, color='gray')
        
        # Add extended grid lines to resource chart too
        for tick in all_major_ticks:
            line = ax_resource.axvline(x=tick, color='gray', alpha=0.8, linewidth=1.2, zorder=0)
            line._grid_line = True  # Mark for zoom handler
        
        for tick in all_minor_ticks:
            line = ax_resource.axvline(x=tick, color='lightgray', alpha=0.5, linewidth=0.6, zorder=0)
            line._grid_line = True  # Mark for zoom handler
        
        ax_resource.set_xlim(min_start_time, max_end_time)
        ax_resource.tick_params(axis='both', labelsize=font_sizes['tick'])
        ax_resource.tick_params(axis='x', which='major', length=6)
        
        # Tight layout with adaptive padding
        plt.tight_layout(pad=1.0 + fig_height * 0.02)
        
        # Enable zoom/pan functionality if requested
        if interactive and enable_zoom:
            zoom_handler = ZoomHandler(fig, ax_gantt, ax_resource, time_grid, min_start_time, max_end_time, self, resource_bars)
            print("Dynamic zoom enabled: smart time labeling, extended grid lines, fixed resource bar width, resource Y-axis locked")
            if hasattr(ax_gantt, '_pending_text_elements'):
                zoom_handler.text_elements = ax_gantt._pending_text_elements
                print(f"Connected {len(zoom_handler.text_elements)} text elements for zoom scaling")
                #xd
                delattr(ax_gantt, '_pending_text_elements')
            #print("Dynamic zoom enabled with text scaling")
        elif interactive:
            # Add basic interactive features without zoom
            ax_gantt.set_navigate(True)
            ax_resource.set_navigate(True)
            
            # Add information display on hover (if possible)
            try:
                from matplotlib.widgets import Cursor
                cursor1 = Cursor(ax_gantt, useblit=True, color='red', linewidth=1)
                cursor2 = Cursor(ax_resource, useblit=True, color='red', linewidth=1)
            except:
                pass  # Skip if widgets not available
        
        # Save if requested
        if save_path:
            # Use high DPI for screen adaptation
            save_dpi = max(150, self.screen_info['dpi'] * 1.5)
            fig.savefig(save_path, dpi=save_dpi, bbox_inches='tight', 
                       facecolor='white', edgecolor='none')
            print("Chart saved to: {} (DPI: {})".format(save_path, save_dpi))
        
        return fig, task_lines, zoom_handler
    
    def print_summary(self, tasks, task_lines, makespan, resource_values=None):
        """Prints final summary with adaptive information"""
        print("\n" + "="*60)
        print("ADAPTIVE GANTT CHART SUMMARY")
        print("="*60)
        
        # Display adaptation info
        print("Display Adaptation:")
        print("  Screen: {}x{} ({:.1f}x{:.1f}\")".format(
            self.screen_info['width'], self.screen_info['height'],
            self.screen_info['width_inches'], self.screen_info['height_inches']))
        print("  DPI: {:.0f}".format(self.screen_info['dpi']))
        
        # Time information
        min_start_time = min(task["start"] for task in tasks)
        max_end_time = max(task["end"] for task in tasks)
        chart_duration = max_end_time - min_start_time
        
        print("\nContent Summary:")
        print("  Time span: {} to {} ({} units)".format(min_start_time, max_end_time, chart_duration))
        print("  Total tasks: {}".format(len(tasks)))
        print("  Task lines: {}".format(len(task_lines)))
        print("  Task types: {}".format(len(self.task_colors)))
        
        # Line density analysis
        if len(task_lines) <= 5:
            density_level = "Low"
        elif len(task_lines) <= 10:
            density_level = "Medium"
        elif len(task_lines) <= 15:
            density_level = "High"
        elif len(task_lines) <= 25:
            density_level = "Very High"
        else:
            density_level = "Extreme"
            
        print("  Line density: {} ({} lines)".format(density_level, len(task_lines)))
        
        # Show adaptations made
        print("\nAdaptations Applied:")
        print("  - Progressive time intervals: duration {} -> step {}".format(chart_duration, 
               "varies" if hasattr(self, '_last_time_step') else "auto"))
        print("  - Smart time label visibility: ENABLED (avoids overcrowding)")
        print("  - Dynamic zoom with extended grid lines: ENABLED")
        print("  - Fixed resource bar width during zoom: ENABLED")
        print("  - Resource chart Y-axis locked (no height zoom): ENABLED")
        
        if len(task_lines) > 15:
            print("  - Extended time intervals for clarity")
            print("  - Reduced font sizes to fit content")
            print("  - Simplified task labels")
            print("  - Increased figure width for better readability")
        elif len(task_lines) > 10:
            print("  - Moderate time interval spacing")
            print("  - Adjusted font sizes for optimal readability")
        else:
            print("  - Standard spacing and fonts")
            print("  - Full detail display")
        
        for line_idx, line_info in enumerate(task_lines):
            task_type = line_info['type']
            line_tasks = line_info['tasks']
            line_number = line_info['line_number']
            
            # Count how many lines this type has
            type_line_count = len([l for l in task_lines if l['type'] == task_type])
            
            if type_line_count > 1:
                print("\n{} (Line {}) - {} tasks:".format(task_type, line_number, len(line_tasks)))
            else:
                print("\n{} - {} tasks:".format(task_type, len(line_tasks)))
                
            # Limit detailed output for very busy charts
            if len(task_lines) > 20 and len(line_tasks) > 5:
                # Show first few and summary
                for i, task in enumerate(line_tasks[:3]):
                    print("   |-- {}: {}-{} (duration: {})".format(task['rep_number'], task['start'], task['end'], task['duration']))
                if len(line_tasks) > 3:
                    print("   |-- ... and {} more tasks".format(len(line_tasks) - 3))
            else:
                for task in line_tasks:
                    print("   |-- {}: {}-{} (duration: {})".format(task['rep_number'], task['start'], task['end'], task['duration']))

def main():
    parser = argparse.ArgumentParser(
        description='Generate Adaptive Gantt Chart with Smart Time Labeling',
        epilog='Progressive Time System: 1-50=every 1, 50-100=every 2, 100-150=every 3, 150-200=every 4, etc. Smart time label visibility prevents overcrowding by showing appropriate number labels based on available space. Dynamic zoom provides more detailed time points when zooming in. Grid lines extend beyond view for smooth panning. Resource bars maintain fixed visual width during zoom. Resource chart zoom affects only time axis (X), column height (Y) stays fixed.'
    )
    parser.add_argument('input', nargs='?', help='Input file or command to execute')
    parser.add_argument('-o', '--output', help='Output file for the chart (PNG)')
    parser.add_argument('-t', '--title', default='Workload Scheduling Problem', help='Chart title')
    parser.add_argument('-m', '--mode', choices=['auto', 'fullscreen', 'compact'], default='auto',
                       help='Display mode: auto (adaptive), fullscreen (maximum space), compact (minimal space)')
    parser.add_argument('-s', '--step', type=int, help='Override progressive intervals with specific time step (e.g., 1, 2, 5, 10)')
    parser.add_argument('--exec', action='store_true', help='Execute the provided command')
    parser.add_argument('--stdin', action='store_true', help='Read from stdin')
    parser.add_argument('--no-interactive', action='store_true', help='Disable interactive features')
    parser.add_argument('--no-zoom', action='store_true', help='Disable zoom functionality (keep other interactive features)')
    
    args = parser.parse_args()
    
    generator = AdaptiveGanttChartGenerator()
    
    # Determine input source
    if args.stdin:
        print("Reading from stdin...")
        input_text = sys.stdin.read()
    elif args.exec and args.input:
        print("Executing command: {}".format(args.input))
        try:
            result = subprocess.run(args.input, shell=True, capture_output=True, text=True, encoding='utf-8')
            if result.returncode != 0:
                print("Execution error: {}".format(result.stderr))
                return
            input_text = result.stdout
        except Exception as e:
            print("Error: {}".format(e))
            return
    elif args.input:
        try:
            with open(args.input, 'r', encoding='utf-8') as f:
                input_text = f.read()
        except FileNotFoundError:
            print("File not found: {}".format(args.input))
            return
        except UnicodeDecodeError:
            try:
                with open(args.input, 'r', encoding='latin-1') as f:
                    input_text = f.read()
            except Exception as e:
                print("Error reading file: {}".format(e))
                return
    else:
        # Use example data
        print("Using provided example data...")
        input_text = """Makespan end: 42

Schedule:
Task "Payment_Validation": start=1, end=5
Task "Inventory_Check": start=5, end=9
Task "Inventory_Check" (Rep2): start=5, end=9
Task "Inventory_Check" (Rep3): start=5, end=9
Task "Inventory_Check" (Rep4): start=5, end=9
Task "Shipping_Calculation": start=14, end=24
Task "Shipping_Calculation" (Rep2): start=14, end=24
Task "Shipping_Calculation" (Rep3): start=14, end=24
Task "Shipping_Calculation" (Rep4): start=24, end=34
Task "Order_Confirmation": start=34, end=42

Resource: 4;4;4;4;20;20;20;20;0;0;0;0;0;9;9;9;9;9;9;9;9;9;9;3;3;3;3;3;3;3;3;3;3;2;2;2;2;2;2;2;2;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0"""
    
    # Parse and generate chart
    tasks, makespan, resource_data = generator.parse_output(input_text)
    
    if not tasks:
        print("No tasks found in input!")
        return
    
    # Create adaptive chart
    interactive = not args.no_interactive
    enable_zoom = not args.no_zoom
    result = generator.create_gantt_chart(
        tasks, makespan, resource_data, args.title, 
        args.output, args.mode, interactive, args.step, enable_zoom
    )
    
    # Handle the result (could be None if no tasks, or tuple with fig, task_lines, zoom_handler)
    if result is None or result[0] is None:
        print("No chart generated!")
        return
        
    fig, task_lines, zoom_handler = result
    
    if fig:
        # Parse resource data for summary
        resource_values = generator.parse_resource_data(resource_data, makespan) if resource_data else None
        generator.print_summary(tasks, task_lines, makespan, resource_values)
        
        if not args.output:
            print("\nShowing adaptive chart with smart time labeling...")
            step_info = " | Time step: {}".format(args.step) if args.step else " | Progressive intervals"
            zoom_info = " | Zoom: {}".format("DYNAMIC" if interactive and enable_zoom else "OFF")
            grid_info = " | Extended Grid: ON"
            resource_info = " | Resource Y-Lock: ON"
            label_info = " | Smart Labels: ON"
            print("Mode: {} | Interactive: {}{}{}{}{}{}".format(args.mode, interactive, step_info, zoom_info, grid_info, resource_info, label_info))
            plt.show()
    
    step_info = " | Time step: {}".format(args.step) if args.step else " | Progressive intervals"
    zoom_info = " | Zoom: {}".format("DYNAMIC" if interactive and enable_zoom else "OFF")
    grid_info = " | Extended Grid: ON"
    resource_info = " | Resource Y-Lock: ON"
    label_info = " | Smart Labels: ON"
    print("\nCompleted! Makespan: {}, Tasks: {}, Lines: {}, Mode: {}{}{}{}{}{}".format(
        makespan, len(tasks), len(task_lines), args.mode, step_info, zoom_info, grid_info, resource_info, label_info))

if __name__ == "__main__":
    main()