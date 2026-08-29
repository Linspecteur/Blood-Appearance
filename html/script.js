$(document).ready(function() {
    
    // Tab switching
    $('.tab-btn').on('click', function() {
        const targetTab = $(this).data('tab');
        $('.tab-btn').removeClass('active');
        $(this).addClass('active');
        
        $('.tab-content').removeClass('active');
        $('#tab-' + targetTab).addClass('active');
        
        // Auto camera position based on tab
        if (targetTab === 'identity' || targetTab === 'face_shape' || targetTab === 'hair_makeup' || targetTab === 'skin_details') {
            triggerCam('head');
        } else if (targetTab === 'clothing_top' || targetTab === 'accessories') {
            triggerCam('torso');
        } else if (targetTab === 'clothing_bottom') {
            triggerCam('legs');
        }
    });

    // Camera Helper
    function triggerCam(view) {
        $('.cam-btn[data-cam]').removeClass('active');
        $(`.cam-btn[data-cam="${view}"]`).addClass('active');
        $.post('https://bl_appearance/setCamera', JSON.stringify({ view: view }));
    }

    $('.cam-btn[data-cam]').on('click', function() {
        const view = $(this).data('cam');
        triggerCam(view);
    });

    // Rotation controls
    let rotateInterval = null;
    function startRotate(delta) {
        if (!rotateInterval) {
            rotateInterval = setInterval(function() {
                $.post('https://bl_appearance/rotatePed', JSON.stringify({ delta: delta }));
            }, 40);
        }
    }

    function stopRotate() {
        if (rotateInterval) {
            clearInterval(rotateInterval);
            rotateInterval = null;
        }
    }

    $('#rotate-left').on('mousedown', function() { startRotate(-5.0); });
    $('#rotate-right').on('mousedown', function() { startRotate(5.0); });
    $(document).on('mouseup mouseleave', function() { stopRotate(); });

    // Slider & Stepper input logic
    $('.creator-slider').on('input change', function() {
        const setting = $(this).data('setting');
        const val = parseFloat($(this).val());
        
        if (setting === 'face_mix' || setting === 'skin_mix') {
            $('#val-' + setting).text(val + '%');
        } else {
            $('#val-' + setting).text(val);
        }
        
        $.post('https://bl_appearance/updateComponent', JSON.stringify({
            setting: setting,
            value: val
        }));
    });

    $('.step-btn').on('click', function() {
        const targetId = $(this).data('target');
        const $input = $('#' + targetId);
        let min = parseFloat($input.attr('min'));
        let max = parseFloat($input.attr('max'));
        let step = parseFloat($input.attr('step') || 1);
        let val = parseFloat($input.val());

        if ($(this).hasClass('step-down')) {
            val = Math.max(min, val - step);
        } else {
            val = Math.min(max, val + step);
        }

        $input.val(val).trigger('change');
    });

    // Gender selection buttons
    $('#btn-male, #btn-female').on('click', function() {
        const sex = parseInt($(this).data('sex'));
        $('.gender-btn').removeClass('active');
        $(this).addClass('active');
        
        $.post('https://bl_appearance/changeSex', JSON.stringify({ sex: sex }));
    });

    // Save & Cancel actions
    $('#btn-save').on('click', function() {
        $.post('https://bl_appearance/saveSkin', JSON.stringify({}));
    });

    $('#btn-cancel').on('click', function() {
        $.post('https://bl_appearance/closeMenu', JSON.stringify({}));
    });

    // NUI Message Event Listener
    window.addEventListener('message', function(event) {
        const data = event.data;

        if (data.action === "openMenu") {
            $('#app').removeClass('hidden');
            if (data.skin) {
                applySkinDataToUI(data.skin);
            }
        } else if (data.action === "closeMenu") {
            $('#app').addClass('hidden');
        } else if (data.action === "setMaxValues") {
            if (data.limits) {
                for (let k in data.limits) {
                    const $input = $('#' + k);
                    if ($input.length) {
                        $input.attr('max', data.limits[k]);
                        if (parseFloat($input.val()) > data.limits[k]) {
                            $input.val(data.limits[k]).trigger('change');
                        }
                    }
                }
            }
        } else if (data.action === "setSkinData") {
            applySkinDataToUI(data.skin);
        }
    });

    function applySkinDataToUI(skin) {
        if (!skin) return;

        if (skin.sex === 1) {
            $('.gender-btn').removeClass('active');
            $('#btn-female').addClass('active');
        } else {
            $('.gender-btn').removeClass('active');
            $('#btn-male').addClass('active');
        }

        for (let key in skin) {
            const $input = $('#' + key);
            if ($input.length) {
                $input.val(skin[key]);
                if (key === 'face_mix' || key === 'skin_mix') {
                    $('#val-' + key).text(skin[key] + '%');
                } else {
                    $('#val-' + key).text(skin[key]);
                }
            }
        }
    }
});
