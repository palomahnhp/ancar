require 'rails_helper'

feature "Entry Indicators" do

  describe "muestra datos de una unidad " do
    it 'primera unidad de la organización' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      click_link("Procesos y subprocesos", :match => :first)
      click_link('Periodo de análisis de datos Distritos (Cerrado)', :match => :first)
      within('div#unit') do
        expect(page).to have_content 'DEPARTAMENTO DE SERVICIOS JURIDICOS'
      end

    end

    it 'cambia de unidad' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)

      click_link("Procesos y subprocesos", :match => :first)
      click_link('Periodo de análisis de datos Distritos (Cerrado)', :match => :first)
      click_link 'SECRETARIA DE DISTRITO'
      within('div#unit') do
        expect(page).to have_content 'SECRETARIA DE DISTRITO'
      end
    end

    it 'muestra efectivos de unidad' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first
      add_staff("Unit", unit.id, unit.id, period, 1, 0.5, 1, 0.5)
      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      within("table#staff_Unit") do
        expect(page).to have_content("1,0", count: 2)
        expect(page).to have_content("0,5", count: 2)
      end
    end
  end

  describe "Process" do

    it ' show SGT data' do
      user= create(:user, :SGT)
      login_as_authenticated_user(user)

      organization_role = Organization.find_roles(:interlocutor, user).first

      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first


      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link('Periodo de análisis de datos SGT 2')
      end

      expect(page).to have_content 'SECRETARIA GENERAL TECNICA DEL AREA DE GOBIERNO DE DESARROLLO URBANO SOSTENIBLE'
      expect(page).to have_content '1. RÉGIMEN JURÍDICO'
      expect(page).to have_content '1.1. ASUNTOS JUNTA GOBIERNO, PLENO Y COMISIONES DEL PLENO'
      expect(page).to have_content  '- Revisión jurídica, preparación de documentación y petición de inforems de los asuntos a tratar en la Comisión Preparatoria ..'
      expect(page).to have_content 'Nº informes solicitados por otras Áreas de Gobierno'
      expect(page).to have_content 'Nº de asuntos tratados en la Junta de Gobierno'
      expect(page).to have_content '1.2. PROYECTOS NORMATIVOS'
      expect(page).to have_content 'Preparación revisión y tramitación de proyectos normativos ...'
      expect(page).to have_content 'Nº de proyectos de otras Áreas	Elaboración Propia'
  end

    it ' show Distritos data' do
      user= create(:user, :distrito)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

    end

  end

  describe 'formulario de actualización' do

    it 'es editable si usuario con permiso y periodo abierto: aparecen botones y campos imput ' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

    end
    it 'no es editable si usuario sin permiso y periodo abierto no botones y campos input' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

    end
    it 'no es editable si periodo cerrado' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

    end
    it 'no es editable si tiene VºBº del validador' do
      user= create(:user, :with_two_organizations)
      login_as_authenticated_user(user)
      organization_role = Organization.find_roles(:interlocutor, user).first
      organization = Organization.find(organization_role.resource_id)
      unit = organization.units.first

      period = Period.first

      click_link("Procesos y subprocesos", :match => :first)

      within("#organization_#{organization.id}") do
        click_link 'Periodo de análisis de datos Distritos (Cerrado)'
      end

      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
      expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

    end

    describe " botones en entrada de datos  " do
      it ' Sin cambios de plantilla ' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'


      end
      it ' Con cambios de plantilla' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

      end
    end

    describe "Acciones y Validaciones comunes Guardar Datos y Cerrar entrada datos " do
      it ' coherencia indicadores: cantidad/plantilla asignada' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

      end
      it ' plantilla utilizada mayor que asignada' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

      end
      it ' mayor salida que stock/entrada' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

      end
    end

    describe "Acciones y Validaciones exclusiva de Cerrar entrada datos " do
      it ' datos sin cumplimentar' do
        user= create(:user, :with_two_organizations)
        login_as_authenticated_user(user)
        organization_role = Organization.find_roles(:interlocutor, user).first
        organization = Organization.find(organization_role.resource_id)
        unit = organization.units.first

        period = Period.first

        click_link("Procesos y subprocesos", :match => :first)

        within("#organization_#{organization.id}") do
          click_link 'Periodo de análisis de datos Distritos (Cerrado)'
        end

        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO JURIDICO'
        expect(page).to have_content 'TRAMITACIÓN Y SEGUIMIENTO DE CONTRATOS Y CONVENIOS DEPARTAMENTO TÉCNICO'

      end
    end
  end
end
