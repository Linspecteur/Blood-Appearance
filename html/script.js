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
        if (!view) return;
        $('.cam-btn[data-cam]').removeClass('active');
        $(`.cam-btn[data-cam="${view}"]`).addClass('active');
        $.post('https://bl_appearance/setCamera', JSON.stringify({ view: view }));
    }

    $('.cam-btn[data-cam]').on('click', function() {
        const view = $(this).data('cam');
        triggerCam(view);
    });

    // Auto camera on card focus/click
    $(document).on('click', '.clothing-card', function() {
        const cat = $(this).data('category');
        if (cat) {
            triggerCam(cat);
        }
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

    // Update UI elements for a setting
    function updateUIElements(setting, val) {
        if (setting === 'face_mix' || setting === 'skin_mix') {
            $('#val-' + setting).text(val + '%');
        } else {
            $('#val-' + setting).text(val);
        }

        // Update Model Badge
        const $badge = $('#badge-' + setting);
        if ($badge.length) {
            if (val === -1) {
                $badge.text('Aucun');
            } else {
                $badge.text('#' + val);
            }
        }
    }

    // Slider input logic
    $('.creator-slider').on('input change', function(e, fromSync) {
        const setting = $(this).data('setting');
        const val = parseFloat($(this).val());
        
        updateUIElements(setting, val);
        
        if (!fromSync) {
            $.post('https://bl_appearance/updateComponent', JSON.stringify({
                setting: setting,
                value: val
            }));
        }
    });

    // Stepper buttons (both fast ±10 and normal ±1)
    $(document).on('click', '.step-btn', function() {
        const targetId = $(this).data('target');
        const $input = $('#' + targetId);
        if (!$input.length) return;

        let min = parseFloat($input.attr('min') || 0);
        let max = parseFloat($input.attr('max') || 100);
        let step = parseFloat($(this).data('step') || $input.attr('step') || 1);
        let val = parseFloat($input.val() || 0);

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
                applyLimits(data.limits);
            }
            if (data.skin) {
                applySkinDataToUI(data.skin);
            }
        } else if (data.action === "setSkinData") {
            applySkinDataToUI(data.skin);
        }
    });

    function applyLimits(limits) {
        for (let k in limits) {
            const maxVal = limits[k];
            const $input = $('#' + k);
            if ($input.length) {
                $input.attr('max', maxVal);
                
                // If it's a texture slider
                const $maxLabel = $('#max-' + k);
                if ($maxLabel.length) {
                    $maxLabel.text(maxVal);
                }

                // Check for single texture (unique)
                const $box = $('#box-' + k).closest('.texture-stepper-box');
                const $uniqueBadge = $('#unique-' + k);
                if ($box.length) {
                    if (maxVal <= 0) {
                        $box.addClass('is-unique');
                        $uniqueBadge.addClass('active');
                    } else {
                        $box.removeClass('is-unique');
                        $uniqueBadge.removeClass('active');
                    }
                }

                // Clamp current value if exceeding
                if (parseFloat($input.val()) > maxVal) {
                    $input.val(Math.max(parseFloat($input.attr('min') || 0), 0)).trigger('change');
                }
            }
        }
    }

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
                updateUIElements(key, skin[key]);
            }
        }
    }
});
