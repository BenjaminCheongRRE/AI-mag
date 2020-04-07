classdef InductorGui < handle
    %% init
    properties (SetAccess = private, GetAccess = public)
        id_fig
        inductor_display_obj
    end
    properties (SetAccess = private, GetAccess = public)
        id_select
        plot_data
        fom_data
        operating_data
        txt
    end
        
    %% init
    methods (Access = public)
        function self = InductorGui(id_design, fom, operating)
            self.id_fig = randi(1e9);
            self.inductor_display_obj = design_display.InductorDisplay(id_design, fom, operating);
        end
        
        function set_id_select(self, id_select)
            assert(length(id_select)==1, 'invalid data');
            [self.plot_data, self.fom_data, self.operating_data, self.txt] = self.inductor_display_obj.get_data_id(id_select);
            self.id_select = id_select;
            
            is_found = gui.GuiUtils.find_gui(self.id_fig);
            if is_found==true
                self.update_gui();
            end
        end
        
        function close_gui(self)
            gui.GuiUtils.close_gui(self.id_fig);
        end
        
        function open_gui(self)
            self.update_gui();
        end
    end
    
    methods (Access = private)
        function fig = update_gui(self)
            name = sprintf('InductorDisplay / id_design = %d', self.id_select);
            fig = gui.GuiUtils.get_gui(self.id_fig, [200 200 1390 800], name);

            panel_plot = gui.GuiUtils.get_panel(fig, [10 10 450 780], 'Plot');
            self.display_plot(panel_plot);
            
            panel_inductor_header = gui.GuiUtils.get_panel(fig, [470 720 450 70], 'Inductor');
            panel_inductor_data = gui.GuiUtils.get_panel(fig, [470 80 450 630], []);
            self.display_inductor(panel_inductor_header, panel_inductor_data);

            panel_operating_header = gui.GuiUtils.get_panel(fig, [930 720 450 70], 'Operating');
            panel_operating_data = gui.GuiUtils.get_panel(fig, [930 80 450 630], []);
            self.display_operating(panel_operating_header, panel_operating_data);
            
            panel_logo = gui.GuiUtils.get_panel(fig, [930 10 450 60], []);
            self.display_logo(panel_logo);
            
            panel_button = gui.GuiUtils.get_panel(fig, [470 10 450 60], []);
            self.display_button(panel_button);
        end

        function display_logo(self, panel)
            filename = 'logo_pes_ethz.png';
            path = fileparts(mfilename('fullpath'));
            filename = [path filesep() filename];
            gui.GuiUtils.set_logo(panel, filename);
        end
        
        function display_button(self, panel)            
            callback = @(src,event) self.callback_save();
            gui.GuiUtils.get_button(panel, [0.02 0.1 0.46 0.8], 'Save', callback);
            
            callback = @(src,event) self.callback_copy();
            gui.GuiUtils.get_button(panel, [0.52 0.1 0.46 0.8], 'Copy', callback);
        end
                
        function callback_save(self)
           [file, path, indx] = uiputfile('*.png');
           if indx~=0
               fig = figure(self.id_fig);
               img = getframe(fig);
               imwrite(img.cdata, [path file])
           end
        end

        function callback_copy(self)
            clipboard('copy', self.txt)
        end
        
        function callback_menu(self, menu_obj, is_valid_vec, obj_vec)      
            idx = gui.GuiUtils.get_menu_idx(menu_obj);
            
            for i=1:length(obj_vec)
                if i==idx
                    obj_vec(i).set_visible(true);
                else
                    obj_vec(i).set_visible(false);
                end
            end
            
            is_valid_tmp = is_valid_vec(idx);
            gui.GuiUtils.set_menu(menu_obj, is_valid_tmp);
        end

        function display_operating(self, panel_header, panel_data)
            field = fieldnames(self.operating_data);
            for i=1:length(field)
                is_valid_tmp = self.operating_data.(field{i}).is_valid;
                text_data_tmp = self.operating_data.(field{i}).text_data;

                gui_text_obj_tmp = gui.GuiText(panel_data, 10, [10, 25, 240]);
                gui_text_obj_tmp.set_text(text_data_tmp);
                
                obj_vec(i) = gui_text_obj_tmp;
                is_valid_vec(i) = is_valid_tmp;
            end
                            
            callback = @(menu_obj, event) self.callback_menu(menu_obj, is_valid_vec, obj_vec);
            menu_obj = gui.GuiUtils.get_menu(panel_header, [0.02 0.75 0.96 0.0], field, callback);
            self.callback_menu(menu_obj, is_valid_vec, obj_vec);
        end
        
        function display_inductor(self, panel_header, panel_data)
            
            status = gui.GuiUtils.get_status(panel_header, [0.02 0.13 0.96 0.62]);
            gui.GuiUtils.set_status(status, self.fom_data.is_valid);

            gui_text_obj = gui.GuiText(panel_data, 10, [10, 25, 240]);
            gui_text_obj.set_text(self.fom_data.text_data);
        end
        
        function display_plot(self, panel)
            gui_geom_front_obj = gui.GuiGeom(panel, [0.0 0.02 1.0 0.48]);
            gui_geom_top_obj = gui.GuiGeom(panel, [0.0 0.52 1.0 0.48]);

            if self.plot_data.is_valid==true
                gui_geom_front_obj.set_plot_geom_data(self.plot_data.plot_data_front, 0.1);
                gui_geom_top_obj.set_plot_geom_data(self.plot_data.plot_data_top, 0.1);
            else
                gui_geom_front_obj.set_plot_geom_cross()
                gui_geom_top_obj.set_plot_geom_cross()
            end
        end
    end
end